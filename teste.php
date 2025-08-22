<?php
header('Content-Type: application/json');

$folder = "Alternador de Empresa";

// Verificar se pasta existe
if (!is_dir($folder)) {
    echo json_encode(["status" => "error", "message" => "Pasta não existe"]);
    exit;
}

// Listar arquivos simples
$files = [];
$di = new RecursiveDirectoryIterator($folder, RecursiveDirectoryIterator::SKIP_DOTS);
$iterator = new RecursiveIteratorIterator($di);

foreach ($iterator as $file) {
    if ($file->isFile()) {
        $files[] = [
            'name' => $file->getFilename(),
            'path' => $file->getRealPath(),
            'size' => $file->getSize()
        ];
    }
}

echo json_encode([
    "status" => "success",
    "folder" => realpath($folder),
    "file_count" => count($files),
    "files" => $files
]);
?>