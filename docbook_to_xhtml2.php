<?php
$proc = new XSLTProcessor();

$xslt = new DOMDocument();
$xslt->load('docbook_to_xhtml2.xsl');
$proc->importStylesheet($xslt);

ob_start('fixIndent');

$data = new DOMDocument();
$data->load('php://stdin');
$proc->transformToURI($data, 'php://output');

function fixIndent($string)
{
	return str_replace('  ', '	', $string);
}