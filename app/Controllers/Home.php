<?php namespace App\Controllers;

use Sssm\Controllers\SssmBaseController;

class Home extends SssmBaseController
{
    
    public function __construct(){
        if( !file_exists( WRITEPATH . 'sssm_was_installed' ) ){
        
        }
    }
    
    public function index()
	{
		return view(__METHOD__,[],[], $this);
	}

}
