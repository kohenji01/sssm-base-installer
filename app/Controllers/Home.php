<?php namespace App\Controllers;

use Sssm\Base\Controllers\UserBaseController;

class Home extends UserBaseController
{
    
    public function __construct(){
        if( !file_exists( WRITEPATH . 'sssm_was_installed' ) ){
        
        }
    }
    
    public function index()
	{
		return $this->view(__METHOD__);
	}

}
