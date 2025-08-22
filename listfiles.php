<?php
$folder = "Alternador de Empresa";

if (!is_dir($folder)) {
    http_response_code(404);
    exit("PASTA_NAO_ENCONTRADA");
}

// Listar todos os arquivos
$files = new RecursiveIteratorIterator(
    new RecursiveDirectoryIterator($folder, RecursiveDirectoryIterator::SKIP_DOTS),
    RecursiveIteratorIterator::LEAVES_ONLY
);

$fileList = [];
foreach ($files as $file) {
    if ($file->isFile()) {
        $filePath = $file->getRealPath();
        $relativePath = substr($filePath, strlen(realpath($folder)) + 1);
        $fileList[] = [
            'path' => $relativePath,
            'content' => base64_encode(file_get_contents($filePath))
        ];
    }
}

header('Content-Type: application/json');
echo json_encode($fileList);
exit;
?>