<?php
// Permitir CORS
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

$folder = "Alternador de Empresa";

// Debug: Verificar se a pasta existe
if (!is_dir($folder)) {
    echo json_encode([
        "error" => "PASTA_NAO_ENCONTRADA", 
        "message" => "Pasta não encontrada: " . realpath($folder)
    ]);
    exit;
}

// Debug: Listar conteúdo da pasta
$files = scandir($folder);
echo "Conteúdo da pasta: " . print_r($files, true) . "<br>";

$fileList = [];
$iterator = new RecursiveIteratorIterator(
    new RecursiveDirectoryIterator($folder, RecursiveDirectoryIterator::SKIP_DOTS),
    RecursiveIteratorIterator::LEAVES_ONLY
);

foreach ($iterator as $file) {
    if ($file->isFile()) {
        $filePath = $file->getRealPath();
        $relativePath = substr($filePath, strlen(realpath($folder)) + 1);
        
        $fileList[] = [
            'path' => str_replace('\\', '/', $relativePath),
            'content' => base64_encode(file_get_contents($filePath)),
            'size' => filesize($filePath)
        ];
    }
}

if (empty($fileList)) {
    echo json_encode([
        "error" => "PASTA_VAZIA",
        "debug" => [
            "folder_path" => realpath($folder),
            "folder_contents" => scandir($folder)
        ]
    ]);
} else {
    echo json_encode([
        "success" => true,
        "fileCount" => count($fileList),
        "files" => $fileList
    ]);
}
exit;
?>