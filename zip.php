<?php
$folder = __DIR__ . "/Alternador de Empresa";  // caminho da pasta no servidor
$zipName = "Alternador_de_Empresa.zip";

// Carrega a classe ZipArchive
$zip = new ZipArchive();
$zipPath = sys_get_temp_dir() . "/" . $zipName;

if ($zip->open($zipPath, ZipArchive::CREATE | ZipArchive::OVERWRITE) !== TRUE) {
    exit("Não foi possível criar o arquivo ZIP.");
}

// Função para adicionar arquivos recursivamente
$files = new RecursiveIteratorIterator(
    new RecursiveDirectoryIterator($folder, RecursiveDirectoryIterator::SKIP_DOTS),
    RecursiveIteratorIterator::SELF_FIRST
);

foreach ($files as $file) {
    $filePath = realpath($file);
    if (is_dir($filePath)) {
        $zip->addEmptyDir(str_replace($folder . "/", '', $filePath . '/'));
    } else {
        $zip->addFile($filePath, str_replace($folder . "/", '', $filePath));
    }
}

$zip->close();

// Força o download do ZIP
header('Content-Type: application/zip');
header('Content-Disposition: attachment; filename="' . $zipName . '"');
header('Content-Length: ' . filesize($zipPath));

readfile($zipPath);
unlink($zipPath); // limpa arquivo temporário
exit;
