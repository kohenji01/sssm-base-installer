<?php namespace App\Controllers;

use Sssm\Base\Controllers\UserBaseController;

class Home extends UserBaseController
{
    
    public function index()
    {
        $this->smarty->assign( 'sssm_was_installed' , file_exists( WRITEPATH . 'sssm_was_installed' ) );
        return $this->view(__METHOD__);
    }
    
}
