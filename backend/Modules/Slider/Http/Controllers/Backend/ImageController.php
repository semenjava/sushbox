<?php

namespace Modules\Slider\Http\Controllers\Backend;

use Illuminate\Http\Request;
use Modules\Slider\Entities\Image;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Storage;
use App\Http\Controllers\Backend\BackendBaseController;
use App\Authorizable;

class ImageController extends BackendBaseController
{
    use Authorizable;

    public function __construct()
    {
        // Page Title
        $this->module_title = 'Slider';

        // module name
        $this->module_name = 'slider';

        // directory path of the module
        $this->module_path = 'slider::backend';

        // module icon
        $this->module_icon = 'fa-regular fa-sun';

        // module model name, path
        $this->module_model = "Modules\Slider\Entities\Image";
    }

    // public function index()
    // {
    //     $images = Image::all();
    //     return view('slider::images.index', compact('images'));
    // }

    // public function create()
    // {
    //     return view('slider::images.create');
    // }

    // public function store(Request $request)
    // {
    //     $request->validate([
    //         'image' => 'required|image',
    //     ]);

    //     $path = $request->file('image')->store('images', 'public');

    //     Image::create([
    //         'filename' => $request->file('image')->getClientOriginalName(),
    //         'path' => $path,
    //     ]);

    //     return redirect()->route('slider.images.index');
    // }
}

