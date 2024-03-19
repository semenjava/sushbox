<?php

namespace Modules\Category\Http\Controllers\Backend;

use App\Authorizable;
use App\Http\Controllers\Backend\BackendBaseController;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class CategoriesController extends BackendBaseController
{
    use Authorizable;

    public function __construct()
    {
        // Page Title
        $this->module_title = 'Categories';

        // module name
        $this->module_name = 'categories';

        // directory path of the module
        $this->module_path = 'category::backend';

        // module icon
        $this->module_icon = 'fa-solid fa-sitemap';

        // module model name, path
        $this->module_model = "Modules\Category\Models\Category";
    }

    /**
     * Store a newly created resource in storage.
     *
     * @return Response
     */
    public function store(Request $request)
    {
        $module_title = $this->module_title;
        $module_name = $this->module_name;
        $module_path = $this->module_path;
        $module_icon = $this->module_icon;
        $module_model = $this->module_model;
        $module_name_singular = Str::singular($module_name);

        $module_action = 'Store';

        $validatedData = $request->validate([
            'name' => 'required|max:191|unique:'.$module_model.',name',
            'code' => 'required|max:191|unique:'.$module_model.',code',
            'is_product_category' => 'nullable|boolean',
            'is_ingredient_category' => 'nullable|boolean',
            'is_preparation_category' => 'nullable|boolean',
            'show_preferences' => 'nullable|boolean',
        ]);

        $data = $request->except(['image', '_token']);
        $data['is_product_category'] = $request->has('is_product_category') ? 1 : 0;
        $data['is_ingredient_category'] = $request->has('is_ingredient_category') ? 1 : 0;
        $data['is_preparation_category'] = $request->has('is_preparation_category') ? 1 : 0;
        $data['show_preferences'] = $request->has('show_preferences') ? 1 : 0;

        $$module_name_singular = $module_model::create($data);

        if ($request->image) {
            $media = $$module_name_singular->addMedia($request->file('image'))->toMediaCollection($module_name);
            $$module_name_singular->image = $media->getUrl();
            $$module_name_singular->save();
        }

        flash(icon()."New '".Str::singular($module_title)."' Added")->success()->important();

        logUserAccess($module_title.' '.$module_action.' | Id: '.$$module_name_singular->id);

        return redirect("admin/{$module_name}");
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return Response
     */
    public function show($id)
    {
        $module_title = $this->module_title;
        $module_name = $this->module_name;
        $module_path = $this->module_path;
        $module_icon = $this->module_icon;
        $module_model = $this->module_model;
        $module_name_singular = Str::singular($module_name);

        $module_action = 'Show';

        $$module_name_singular = $module_model::findOrFail($id);

        logUserAccess($module_title.' '.$module_action.' | Id: '.$$module_name_singular->id);

        return view(
            "{$module_path}.{$module_name}.show",
            compact('module_title', 'module_name', 'module_path', 'module_icon', 'module_name_singular', 'module_action', "{$module_name_singular}")
        );
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  int  $id
     * @return Response
     */
    public function update(Request $request, $id)
    {
        $module_title = $this->module_title;
        $module_name = $this->module_name;
        $module_path = $this->module_path;
        $module_icon = $this->module_icon;
        $module_model = $this->module_model;
        $module_name_singular = Str::singular($module_name);

        $module_action = 'Update';

        $validatedData = $request->validate([
            'name' => 'required|max:191|unique:'.$module_model.',name,'.$id,
            'code' => 'nullable|max:191|unique:'.$module_model.',code,'.$id,
            'is_product_category' => 'nullable|boolean',
            'is_ingredient_category' => 'nullable|boolean',
            'is_preparation_category' => 'nullable|boolean',
            'show_preferences' => 'nullable|boolean',
        ]);

        $$module_name_singular = $module_model::findOrFail($id);

        $data = $request->except('image', 'image_remove', '_token');
        $data['is_product_category'] = $request->has('is_product_category') ? 1 : 0;
        $data['is_ingredient_category'] = $request->has('is_ingredient_category') ? 1 : 0;
        $data['is_preparation_category'] = $request->has('is_preparation_category') ? 1 : 0;
        $data['show_preferences'] = $request->has('show_preferences') ? 1 : 0;

        $$module_name_singular->update($data);

        // Image
        if ($request->hasFile('image')) {
            if ($$module_name_singular->getMedia($module_name)->first()) {
                $$module_name_singular->getMedia($module_name)->first()->delete();
            }
            $media = $$module_name_singular->addMedia($request->file('image'))->toMediaCollection($module_name);

            $$module_name_singular->image = $media->getUrl();

            $$module_name_singular->save();
        }
        if ($request->image_remove === 'image_remove') {
            if ($$module_name_singular->getMedia($module_name)->first()) {
                $$module_name_singular->getMedia($module_name)->first()->delete();

                $$module_name_singular->image = '';

                $$module_name_singular->save();
            }
        }

        flash(icon().' '.Str::singular($module_title)."' Updated Successfully")->success()->important();

        logUserAccess($module_title.' '.$module_action.' | Id: '.$$module_name_singular->id);

        return redirect()->route("backend.{$module_name}.show", $$module_name_singular->id);
    }
}
