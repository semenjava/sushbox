<?php

namespace Components\Properties;

class Property extends BaseProperty
{
    /**
     * @var array
     */
    protected $property = [];

    /**
     * @param $data
     */
    public function __construct($data = array())
    {
        if (!empty($data)) {
            $this->setInstaceProperty($data);
        }
    }

    /**
     * @param $key
     * @return mixed|null
     */
    public function getProperty($key = null)
    {
        return !isset($this->property[$key]) ? null : $this->property[$key];
    }

    /**
     * @param $key
     * @param $value
     * @return mixed
     */
    public function setProperty($key, $value)
    {
        return $this->property[$key] = $value;
    }

    /**
     * @param $key
     * @param $value
     * @return mixed
     */
    public function set($key, $value)
    {
        return $this->setProperty($key, $value);
    }

    /**
     * @param $key
     * @return string
     */
    public function getUcfirst($key)
    {
        return ucfirst($this->property[$key]);
    }

    /**
     * @param $key
     * @return string
     */
    public function getLcfirst($key)
    {
        return lcfirst($this->property[$key]);
    }

    /**
     * @param $key
     * @param $value
     * @return void
     */
    public function add($key, $value)
    {
        if (is_array($value) && is_array($this->get($key))) {
            $arr = array_merge($this->get($key), $value);
            $this->set($key, $arr);
        } else {
            $this->set($key, $value);
        }
    }

    /**
     * @param $key
     * @return bool
     */
    public function has($key)
    {
        return !empty($this->property[$key]);
    }

    /**
     * @param $key
     * @return mixed|null
     */
    public function get($key)
    {
        return $this->getProperty($key);
    }

    /**
     * @return array
     */
    public function all()
    {
        return $this->property;
    }

    /**
     * @return void
     */
    public function clearAll()
    {
        $this->property = [];
    }

    /**
     * @param $key
     * @return null
     */
    public function remove($key)
    {
        if (!empty($this->property[$key])) {
            unset($this->property[$key]);
        }
        return null;
    }

    /**
     * @param $key
     * @param $to_key
     * @return void|null
     */
    public function rename($key, $to_key)
    {
        if (empty($this->property[$key])) {
            return null;
        }
        $value = $this->property[$key];
        $this->remove($key);
        $this->property[$to_key] = $value;
    }

    /**
     * @return \Illuminate\Support\Collection
     */
    public function toCollect()
    {
        return collect($this->property);
    }

    /**
     * @return array
     */
    public function toArray()
    {
        return  $this->property;
    }

    public function toJson($key = null)
    {
        if($key && isset($this->property[$key])) {
            return json_encode($this->property[$key], JSON_UNESCAPED_UNICODE);
        }

        return json_encode($this->property, JSON_UNESCAPED_UNICODE);
    }

    public function getDecodeJson($key)
    {
        $arr = json_decode($this->property[$key], true);
        return !is_array($arr) ? [] : $arr;
    }

    public function covert($param)
    {
        if(is_array($param) && !empty($param[0])) {
            $param = $param[0];
        }
        $param = preg_replace('/[\x00-\x1F\x80-\xFF]/', '', $param);
        $param = stripslashes(html_entity_decode($param));
        $param = str_replace(',]', ']', $param);
        $param = str_replace("'", '"', $param);
        return $param;
    }

    /**
     * @return mixed|null
     */
    public function user()
    {
        if ($this->has('user')) {
            return $this->get('user');
        }
        return null;
    }

    /**
     * @param $key
     * @return int
     */
    public function count($key = null)
    {
        if ($key) {
            return isset($this->property[$key]) ? count($this->property[$key]) : 0;
        }

        return isset($this->property) ? count($this->property) : 0;
    }

    /**
     * @param string $str
     * @return mixed|null
     */
    public function posval(string $str)
    {
        $exps = explode('.', $str);
        if (!empty($exps)) {
            $count = count($exps);
            $val = !empty($this->property[$exps[0]]) ? $this->property[$exps[0]] : null;
            $i = 1;
            while ($i < $count) {
                if (!empty($exps[$i]) && !empty($val[$exps[$i]])) {
                    $val = $val[$exps[$i]];
                } else {
                    $val = null;
                }
                $i ++;
            }
        }
        return $val;
    }

    public function generationName(...$params)
    {
        $str = [];
        foreach ($params as $param) {
            $str[] = '%s';
        }
        $s = '%s_'.implode('_', $str);
        $params[] = config('app.location');

        $cache_name = sprintf($s,
            ...$params
        );

        unset($params);unset($s);unset($str);

        return $cache_name;
    }

    public function getAndRemove($key)
    {
        $value = $this->property[$key];
        $this->remove($key);
        return $value;
    }
}
