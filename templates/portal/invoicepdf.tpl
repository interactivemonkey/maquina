<?php

# Logo
if (file_exists(ROOTDIR.'/images/logo.png')) $pdf->Image(ROOTDIR.'/images/logo.png',20,25,75);
elseif (file_exists(ROOTDIR.'/images/logo.jpg')) $pdf->Image(ROOTDIR.'/images/logo.jpg',20,25,75);
else $pdf->Image(ROOTDIR.'/images/placeholder.png',20,25,75);

# Company Details
$pdf->SetFont('freesans','',13);
$pdf->Cell(0,6,trim($companyaddress[0]),0,1,'R');
$pdf->SetFont('freesans','',9);
for ( $i = 1; $i <= ((count($companyaddress)>6) ? count($companyaddress) : 6); $i += 1) {
	$pdf->Cell(0,4,trim($companyaddress[$i]),0,1,'R');
}
$pdf->Ln(5);

# Header Bar
$invoiceprefix = $_LANG["invoicenumber"];
/*
** This code should be uncommented for EU companies using the sequential invoice numbering so that when unpaid it is shown as a proforma invoice **
if ($status!="Paid") {
	$invoiceprefix = $_LANG["proformainvoicenumber"];
}
*/
$pdf->SetFont('freesans','B',15);
$pdf->SetFillColor(239);
$pdf->Cell(0,8,$invoiceprefix.$invoicenum,0,1,'L','1');
$pdf->SetFont('freesans','',10);
$pdf->Cell(0,6,$_LANG["invoicesdatecreated"].': '.$datecreated.'',0,1,'L','1');
$pdf->Cell(0,6,$_LANG["invoicesdatedue"].': '.$duedate.'',0,1,'L','1');
$pdf->Ln(10);

$startpage = $pdf->GetPage();

# Clients Details
$addressypos = $pdf->GetY();
$pdf->SetFont('freesans','B',10);
$pdf->Cell(0,4,$_LANG["invoicesinvoicedto"],0,1);
$pdf->SetFont('freesans','',9);
if ($clientsdetails["companyname"]) {
	$pdf->Cell(0,4,$clientsdetails["companyname"],0,1,'L');
	$pdf->Cell(0,4,$_LANG["invoicesattn"].": ".$clientsdetails["firstname"]." ".$clientsdetails["lastname"],0,1,'L');
} else {
	$pdf->Cell(0,4,$clientsdetails["firstname"]." ".$clientsdetails["lastname"],0,1,'L');
}
$pdf->Cell(0,4,$clientsdetails["address1"],0,1,'L');
if ($clientsdetails["address2"]) {
	$pdf->Cell(0,4,$clientsdetails["address2"],0,1,'L');
}
$pdf->Cell(0,4,$clientsdetails["city"].", ".$clientsdetails["state"].", ".$clientsdetails["postcode"],0,1,'L');
$pdf->Cell(0,4,$clientsdetails["country"],0,1,'L');
if ($customfields) {
    $pdf->Ln();
    foreach ($customfields AS $customfield) {
        $pdf->Cell(0,4,$customfield['fieldname'].': '.$customfield['value'],0,1,'L');
    }
}
$pdf->Ln(10);

# Invoice Items
$tblhtml = '<table width="100%" bgcolor="#ccc" cellspacing="1" cellpadding="2" border="0">
    <tr height="30" bgcolor="#efefef" style="font-weight:bold;text-align:center;">
        <td width="80%">'.$_LANG['invoicesdescription'].'</td>
        <td width="20%">'.$_LANG['quotelinetotal'].'</td>
    </tr>';
foreach ($invoiceitems AS $item) {
    $tblhtml .= '
    <tr bgcolor="#fff">
        <td align="left">'.nl2br($item['description']).'<br /></td>
        <td align="center">'.$item['amount'].'</td>
    </tr>';
}
$tblhtml .= '
    <tr height="30" bgcolor="#efefef" style="font-weight:bold;">
        <td align="right">'.$_LANG['invoicessubtotal'].'</td>
        <td align="center">'.$subtotal.'</td>
    </tr>';
if ($taxname) $tblhtml .= '
    <tr height="30" bgcolor="#efefef" style="font-weight:bold;">
        <td align="right">'.$taxrate.'% '.$taxname.'</td>
        <td align="center">'.$tax.'</td>
    </tr>';
if ($taxname2) $tblhtml .= '
    <tr height="30" bgcolor="#efefef" style="font-weight:bold;">
        <td align="right">'.$taxrate2.'% '.$taxname2.'</td>
        <td align="center">'.$tax2.'</td>
    </tr>';
$tblhtml .= '
    <tr height="30" bgcolor="#efefef" style="font-weight:bold;">
        <td align="right">'.$_LANG['invoicescredit'].'</td>
        <td align="center">'.$credit.'</td>
    </tr>
    <tr height="30" bgcolor="#efefef" style="font-weight:bold;">
        <td align="right">'.$_LANG['invoicestotal'].'</td>
        <td align="center">'.$total.'</td>
    </tr>
</table>';

$pdf->writeHTML($tblhtml, true, false, false, false, '');

$pdf->Ln(5);

# Transactions
$pdf->SetFont('freesans','B',12);
$pdf->Cell(0,4,$_LANG["invoicestransactions"],0,1);

$pdf->Ln(5);

$pdf->SetFont('freesans','',9);

$tblhtml = '<table width="100%" bgcolor="#ccc" cellspacing="1" cellpadding="2" border="0">
    <tr height="30" bgcolor="#efefef" style="font-weight:bold;text-align:center;">
        <td width="25%">'.$_LANG['invoicestransdate'].'</td>
        <td width="25%">'.$_LANG['invoicestransgateway'].'</td>
        <td width="30%">'.$_LANG['invoicestransid'].'</td>
        <td width="20%">'.$_LANG['invoicestransamount'].'</td>
    </tr>';

if (!count($transactions)) {
    $tblhtml .= '
    <tr bgcolor="#fff">
        <td colspan="4" align="center">'.$_LANG['invoicestransnonefound'].'</td>
    </tr>';
} else {
    foreach ($transactions AS $trans) {
        $tblhtml .= '
        <tr bgcolor="#fff">
            <td align="center">'.$trans['date'].'</td>
            <td align="center">'.$trans['gateway'].'</td>
            <td align="center">'.$trans['transid'].'</td>
            <td align="center">'.$trans['amount'].'</td>
        </tr>';
    }
}
$tblhtml .= '
    <tr height="30" bgcolor="#efefef" style="font-weight:bold;">
        <td colspan="3" align="right">'.$_LANG['invoicesbalance'].'</td>
        <td align="center">'.$balance.'</td>
    </tr>
</table>';

$pdf->writeHTML($tblhtml, true, false, false, false, '');

# Notes
if ($notes) {
    $pdf->Ln(5);
	$pdf->SetFont('freesans','',8);
	$pdf->MultiCell(170,5,$_LANG["invoicesnotes"].": $notes");
}

# Generation Date
$pdf->SetFont('freesans','',8);
$pdf->Ln(5);
$pdf->Cell(180,4,$_LANG['invoicepdfgenerated'].' '.getTodaysDate(),'','','C');

# Payment Status
$endpage = $pdf->GetPage();
$pdf->setPage($startpage);
$pdf->SetXY(85,$addressypos);
if ($status=="Cancelled") {
	$statustext = $_LANG["invoicescancelled"];
    $pdf->SetTextColor(245,245,245);
} elseif ($status=="Unpaid") {
	$statustext = $_LANG["invoicesunpaid"];
    $pdf->SetTextColor(204,0,0);
} elseif ($status=="Paid") {
	$statustext = $_LANG["invoicespaid"];
    $pdf->SetTextColor(153,204,0);
} elseif ($status=="Refunded") {
	$statustext = $_LANG["invoicesrefunded"];
    $pdf->SetTextColor(34,68,136);
} elseif ($status=="Collections") {
	$statustext = $_LANG["invoicescollections"];
    $pdf->SetTextColor(255,204,0);
}
$pdf->SetFont('freesans','B',40);
$pdf->Cell(110,20,strtoupper($statustext),0,0,'C');
$pdf->setPage($endpage);

?>