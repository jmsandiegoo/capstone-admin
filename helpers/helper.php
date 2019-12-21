<?php
class Helper
{
    private $defaultPath;

    public function __construct()
    {
        $this->defaultPath = ($_SERVER['SERVER_NAME'] == 'localhost') ? '/capstone-admin/' : '/' ;
    }

    public function subviewPath($file) { // return a path to include subviews
        $file =  __DIR__ . '/../views/sub-views/'. $file;
        return $file;
    }

    function cssPath($file) { // return a css file path to for href attributes
        $hrefPath = $this->defaultPath .'assets/css/'. $file;
        return $hrefPath;
    }

    function jsPath($file) { // return a js file path to for src attributes
        $hrefPath = $this->defaultPath . 'assets/js/'. $file;
        return $hrefPath;
    }

    function pageUrl($file) { // return a page path for href navigation
        $httpProtocol = !isset($_SERVER['HTTPS']) || $_SERVER['HTTPS'] != 'on' ? 'http' : 'https';
        $url = $httpProtocol . '://' . $_SERVER['HTTP_HOST'] . $this->defaultPath;
        if ($file !== 'index.php') {
            $url .= 'views/' . $file;
        }
        return $url;
    }

    function flatten_array($array, $prefix = '' ) {
        $result = array();
        foreach ($array as $key => $value) {
            
        }
    }
    function subPageUrl($file) { // return a page path for href navigation
        $httpProtocol = !isset($_SERVER['HTTPS']) || $_SERVER['HTTPS'] != 'on' ? 'http' : 'https';
        $url = $httpProtocol . '://' . $_SERVER['HTTP_HOST'] . $this->defaultPath;
        if ($file !== 'index.php') {
            $url .= 'views/sub-views/' . $file;
        }
        return $url;
    }
}
?>