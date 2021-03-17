<?php

//delete old data

//$nameOfprofitabilityFile = $argv[1];

//$surebetsNodes = findAllSurebets('/var/www/cgi-bin/results/tmp/Poland_profitability.xml');

$surebet_db_path = '/var/www/data/surebets.db';
$resultPath = '/var/www/cgi-bin/results/';

delete_old_surebets_data( $surebet_db_path );
$profitabilityFilesList = find_last_profitability_files( $resultPath );


foreach( $profitabilityFilesList as $profitabilityFile )
{
        
        $surebetsInfoList = findAllSurebets( $profitabilityFile );
        export_surebetsToDB( $surebetsInfoList, $surebet_db_path );
        //print_r( $profitabilityFile ); 

}


function delete_old_surebets_data( $surebet_db_path )
{
                $db = new SQLite3( $surebet_db_path );
                $deleteQuery = "delete from Surebets_1X2;";
                $db->query( $deleteQuery );
}

function find_last_profitability_files( $dir_with_results )
{

        $last_results_directory = find_last_created_dir($dir_with_results);
        print_r("Searching for surebets in directory $last_results_directory\n");
        $profitabilityFiles = scandir($last_results_directory);
        $profitabilityFiles = array_diff($profitabilityFiles, array('.', '..'));
        foreach($profitabilityFiles as $index => $file)
        {
                $profitabilityFiles[$index] = $last_results_directory . "/" . $file;
        }

        return $profitabilityFiles;

}

function is_special_dir( $file_name_to_check)
{
        
        if( $file_name_to_check == '.' )
        {
                return true;
        }
        elseif( $file_name_to_check == '..' )
        {
                return true;
        }
        else
        {
                return false;
        }

}

function find_last_created_dir( $parrent_directory_path )
{

        $newestFile_creation_time = 0;
        $newestFilePath;

        foreach( new DirectoryIterator($parrent_directory_path) as $file )
        {

                $creation_time = $file->getCTime();
                $fileName = $file->getFileName(); 

                $isSpecialFile = is_special_dir( $fileName );

                if( !$isSpecialFile and $creation_time > $newestFile_creation_time)
                {
                        $newestFile_creation_time = $creation_time;
                        $newestFilePath = $fileName;
                }
        }

        $newestDirectory = $parrent_directory_path . $newestFilePath;
        
        return $newestDirectory;
}


function export_surebetsToDB( $surebetsInfoList, $pathToDB )
{

        //print_r( $surebetsInfoList );

       
        foreach( $surebetsInfoList as $urlToEvent => $surebetInfoEntry  )
        {
                #name of fields can be inserted automaticly by key name
                $insertQuery = 'insert into Surebets_1X2 (profit, homeTeam, visitingTeam, bookmaker_1, bookmaker_X, bookmaker_2, price_1, price_X, price_2) values ';
                $homeTeam = $surebetInfoEntry['home'];
                $homeTeam = $urlToEvent;

                $visitingTeam = $surebetInfoEntry['visitor'];
                $bookmaker_1 = ($surebetInfoEntry['_1X2']->_1->children()[0]->getName()) ; 
                $bookmaker_X = ($surebetInfoEntry['_1X2']->_X->children()[0]->getName()) ; 
                $bookmaker_2 = ($surebetInfoEntry['_1X2']->_2->children()[0]->getName()) ; 
                $price_1 = $surebetInfoEntry['_1X2']->_1->$bookmaker_1;
                $price_X = $surebetInfoEntry['_1X2']->_X->$bookmaker_X;
                $price_2 = $surebetInfoEntry['_1X2']->_2->$bookmaker_2;
                $profit =  $surebetInfoEntry['_1X2']->profit;


                $insertQueryValues = sprintf( '(%f, "%s", "%s", "%s", "%s", "%s", %f, %f, %f );', $profit, $homeTeam, $visitingTeam, $bookmaker_1, $bookmaker_X, $bookmaker_2, $price_1, $price_X, $price_2 );
               
                $insertQuery .= $insertQueryValues;

                //print_r ("Insert query $insertQuery\n");
                $db = new SQLite3($pathToDB);
                //print_r ($surebetNode);
                $results = $db->query($insertQuery);
                //print_r($results);

        } 

}




function findAllSurebets( $profitabilityFile )
{

        $surebetInfo = array();
        $profitXml = simplexml_load_file( $profitabilityFile );

        if(! $profitXml )
        {
                return $surebetInfo;
        };

        foreach ($profitXml->xpath('//event') as $event_node)
        {
                if( $event_node->bestCombinations->_1X2->profit > 0 )
                {

                        $urlToEvent = (string)($event_node['url']);     

                        print_r("Found surebet for event $urlToEvent\n"); 
                        $surebetInfo[$urlToEvent] = array( 'home' => 'Wiarusy'
                                                , 'visitor' => 'Clo'
                                                , 'date' => '2000.01.01'
                                                , '_1X2' =>  $event_node->bestCombinations->_1X2
                                                );
                }
        }

        //print_r($surebetInfo);
        return $surebetInfo;
}


?>
