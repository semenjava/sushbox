<?php

namespace App\Services;

use GuzzleHttp\Client;
use App\Models\Category;
use App\Models\Items;
use Illuminate\Support\Facades\DB;
use App\Models\Menu;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\File;

class ImportItemsService
{
    private $link;
    private $response;
    private $client;

    public function __construct($link)
    {
        $this->link = $link;
    }

    public function connect()
    {
        $this->client = new Client();
    }

    public function instance()
    {
        $this->response = $this->client->get($this->link);
    }

    public function init()
    {
        $this->connect();
        $this->instance();

        return $this;
    }

    public function run()
    {
        $result = json_decode($this->response->getBody()->getContents(), true);

        $data = $result['pageProps']['suggestedCategories']['edges'];

        foreach($data as $i => $value) {
             $exName = explode('/', $value['node']['name']);
             $categoryId = $i+1;
             $category = Category::find($categoryId);
             $menu = Menu::where('category_id', $category->id)->first();

             foreach($value['node']['products']['edges'] as $item) {
                $item = $item['node'];

                $product = [];
                $product['uid'] = md5($category->code.$item['name']);
                $product['category_id'] = $category->id;
                $product['menu_id'] = $menu->id;
                $product['name'] = $item['name'];
                $product['name_en'] = $item['name'];
                $product['comments'] = $item['description'];
                $product['slug'] = $item['slug'];

                $img = $item['image']['sourceUrl'];
                $product['image'] = $this->downloadImage($img);

                $images = explode(', ', $item['image']['srcSet']);
                $item_image = explode(' ', $images[0]);
                $item_thumbnail = explode(' ', $images[1]);
                $product['item_image'] = $this->downloadImage($item_image[0]);
                $product['item_thumbnail'] = $this->downloadImage($item_thumbnail[0]);

                $product['price'] = !empty($item['price']) ? str_replace('€', '', $item['price']) : null;
                $product['take_out_price'] = !empty($item['regularPrice']) ? str_replace('€', '', $item['regularPrice']) : null;
                $product['last_purchase_price'] = !empty($item['salePrice']) ? str_replace('€', '', $item['salePrice']) : null;

                if($item['stockStatus'] == 'IN_STOCK') {
                        $product['is_enabled'] = 1;
                        $product['is_product'] = 1;
                }

                DB::table('items')->updateOrInsert(
                        ['uid' => $product['uid']],
                        $product
                );

            }
        }
    }

    public function downloadImage($img)
    {
        $directory = storage_path('app/public/images');
        $slug = basename($img);
        $savePath = $directory . '/' . $slug;
        if (!File::exists($directory)) {
                File::makeDirectory($directory, 0755, true);
        }

        $client = new Client();
        $response = $client->get($img, ['sink' => $savePath]);

        return '/storage/images/'.$slug;
    }
}
