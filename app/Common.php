<?php

/**
 * The goal of this file is to allow developers a location
 * where they can overwrite core procedural functions and
 * replace them with their own. This file is loaded during
 * the bootstrap process and is called during the frameworks
 * execution.
 *
 * This can be looked at as a `master helper` file that is
 * loaded early on, and may also contain additional functions
 * that you'd like to use throughout your entire application
 *
 * @link: https://codeigniter4.github.io/CodeIgniter4/
 */

use CI4Smarty\Config\Services;

if( !function_exists( 'view' ) ){
    /**
     * Grabs the current RendererInterface-compatible class
     * and tells it to render the specified view. Simply provides
     * a convenience method that can be used in Controllers,
     * libraries, and routed closures.
     *
     * NOTE: Does not provide any escaping of the data, so that must
     * all be handled manually by the developer.
     *
     * @param string $name
     * @param array $data
     * @param array $options Unused - reserved for third-party extensions. 互換性のため維持。無視されます
     * @param object $CI
     *
     * @return string
     */
    function view( string $name , array $data = [] , array $options = [] , object $CI = null ):string{
        try{
            
            unset( $options );
            
            $smarty = Services::smarty();
            list( $class , $file ) = explode( "::" , $name );
            if( substr( $file , 0 , -4 ) != '.tpl' ){
                $file .= '.tpl';
            }
            
            if( class_exists( $class ) ){
                $base_dir = $class;
                $dir = ( new ReflectionClass( $class ) )->getShortName();
            }else{
                $base_dir = '';
                $dir = $class;
            }
            $CI->sssm->include_file['body'] = $base_dir . $dir . DIRECTORY_SEPARATOR . $file;
            $tpl = $CI->sssm->systemName . DIRECTORY_SEPARATOR . $CI->sssm->theme_dir_name . DIRECTORY_SEPARATOR . $CI->sssm->theme . DIRECTORY_SEPARATOR . $CI->sssm->theme_tpl_file_name;
            $smarty->assign( 'CI' , $CI );
            $smarty->assign( 'DATA' , $data );
        }catch( Exception $e ){
            die( 'System error : ' . $e->getMessage() . ( CI_DEBUG ? " at " . $e->getFile() . " : " . $e->getLine() : '' ) );
        }
        
        return $smarty->fetch( $tpl );
    }
}