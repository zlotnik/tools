<?php

//generateSurebetTable('/var/www/data/surebets.db');
function generateSurebetTable( $surebetDB_path )
{
	

    generateTable_Header();

    $surebetsData = array();
    $surebets_SQLiteResultsObject = giveMeSurebetDataFromDB( $surebetDB_path );

    //print_r($surebets_SQLiteResultsObject);

    while( $surebetRow = $surebets_SQLiteResultsObject->fetchArray() )
    {
        generateSingle_table_row($surebetRow);
    }

    generateTable_Footer();

}

function giveMeSurebetDataFromDB( $pathToSurebetDB )
{
        $db = new SQLite3($pathToSurebetDB);
        $selectQuery = "select * from Surebets_1X2;";
        $results = $db->query( $selectQuery );
        //print_r( $results->fetchArray() );
        return $results;
}

function generateTable_Header()
{
    print <<< END
    <table id="box-table-b" summary="Surebets table">
    <thead>
        <tr>
            <th scope="col">Profit</th>
            <th scope="col">Discipline</th>
            <th scope="col">Event name</th>
            <th scope="col">Bookmaker 1</th>
            <th scope="col">Bookmaker X</th>
            <th scope="col">Bookmaker 2</th>
            <th scope="col">Price 1</th>
            <th scope="col">Price X</th>
            <th scope="col">Price 2</th>
        </tr>
    </thead>
    <tbody>
END;
};

function generateTable_Footer()
{
    echo '</tbody>';
    echo '</table>';
}

function removeLeadingUndescore( $text )
{

    $pieces = explode('_',$text);
    return $pieces[1];

}

function generateSingle_table_row($singleSurebet)
{
    print '<tr align="center" >';
    
    $profit = $singleSurebet['profit'];
    $eventName = $singleSurebet['homeTeam'] ." - " . $singleSurebet['visitingTeam'];
    $bookmakerName_1 = removeLeadingUndescore( $singleSurebet['bookmaker_1'] );
    $bookmakerName_x = removeLeadingUndescore( $singleSurebet['bookmaker_X'] );
    $bookmakerName_2 = removeLeadingUndescore( $singleSurebet['bookmaker_2'] );
    $price_1 = $singleSurebet['price_1'];
    $price_x = $singleSurebet['price_X'];
    $price_2 = $singleSurebet['price_2'];

    print '<td align="center">' . $profit . '</td>';
    print "<td>Soccer</td>";
    print "<td>$eventName</td>";
    print "<td>$bookmakerName_1</td>";
    print "<td>$bookmakerName_x</td>";    
    print "<td>$bookmakerName_2</td>";
    print "<td>$price_1</td>";    
    print "<td>$price_x</td>";
    print "<td>$price_2</td>";
    print "</tr>";
    
}
?>
