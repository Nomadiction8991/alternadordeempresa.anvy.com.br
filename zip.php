<?php
$folder = "Alternador de Empresa";
$zipName = "Alternador_de_Empresa.zip";

// Verificar se a pasta existe
if (!is_dir($folder)) {
    exit("Pasta não encontrada");
}

// Criar arquivo ZIP
$zipPath = tempnam(sys_get_temp_dir(), 'zip');
$zip = new ZipArchive();
$zip->open($zipPath, ZipArchive::CREATE);

// Adicionar arquivos
$files = new RecursiveIteratorIterator(
    new RecursiveDirectoryIterator($folder),
    RecursiveIteratorIterator::SELF_FIRST
);

foreach ($files as $file) {
    if ($file->isFile()) {
        $zip->addFile($file->getRealPath(), $file->getFilename());
    }
}

$zip->close();

// Enviar para download
header('Content-Type: application/zip');
header('Content-Disposition: attachment; filename="' . $zipName . '"');
readfile($zipPath);
unlink($zipPath);
?>