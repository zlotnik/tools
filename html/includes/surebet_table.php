<?php 
function generateSurebetTable($surebetData_path)
{
	
    $surebetsData = file($surebetData_path);

    generateTable_Header();

    foreach ($surebetsData as $line_num => $lineWithData) 
    {
        generateSingle_table_row($lineWithData);
    }

    generateTable_Footer();

};

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

function generateSingle_table_row($singleSurebetData)
{
    print '<tr align="center" >';
    
    
    preg_match('/EventName: (.*) PROFIT: (\d+\.\d+|\d+) bookmaker_1 (\w+) bookmaker_x (\w+) bookmaker_2 (\w+) price_1 (\d+\.\d+|\d+) price_X (\d+\.\d+|\d+) price_2 (\d+\.\d+|\d+)/', $singleSurebetData, $matches);
    $eventName = $matches[1];
    $profit = $matches[2];
    $bookmakerName_1 = $matches[3];
    $bookmakerName_x = $matches[4];
    $bookmakerName_2 = $matches[5];
    $price_1 = $matches[6];
    $price_x = $matches[7];
    $price_2 = $matches[8];

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
