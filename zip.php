<?php
$folder = "Alternador de Empresa";
$zipName = "Alternador_de_Empresa.zip";

// Verificar se a pasta existe
if (!is_dir($folder)) {
    http_response_code(404);
    exit("ERRO: Pasta não encontrada no servidor");
}

// Criar arquivo ZIP temporário
$zipPath = tempnam(sys_get_temp_dir(), 'zip_');

$zip = new ZipArchive();
if ($zip->open($zipPath, ZipArchive::CREATE | ZipArchive::OVERWRITE) !== TRUE) {
    exit("ERRO: Não foi possível criar ZIP");
}

// Adicionar arquivos (forma mais simples)
$files = new RecursiveIteratorIterator(
    new RecursiveDirectoryIterator($folder, RecursiveDirectoryIterator::SKIP_DOTS),
    RecursiveIteratorIterator::LEAVES_ONLY
);

foreach ($files as $file) {
    if ($file->isFile()) {
        $zip->addFile($file->getRealPath(), $file->getFilename());
    }
}

$zip->close();

// Headers simples
header('Content-Type: application/zip');
header('Content-Disposition: attachment; filename="' . $zipName . '"');

// Enviar arquivo
readfile($zipPath);
unlink($zipPath);
exit;
?>