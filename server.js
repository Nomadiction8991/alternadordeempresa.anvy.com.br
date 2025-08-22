const express = require('express');
const archiver = require('archiver');
const fs = require('fs');
const path = require('path');

const app = express();
const port = 3000;

app.get('/download-zip', (req, res) => {
    const folderPath = path.join(__dirname, 'Alternador de Empresa');
    const zipName = 'Alternador_de_Empresa.zip';

    // Verificar se a pasta existe
    if (!fs.existsSync(folderPath)) {
        return res.status(404).send('Pasta não encontrada');
    }

    // Configurar headers do ZIP
    res.setHeader('Content-Type', 'application/zip');
    res.setHeader('Content-Disposition', `attachment; filename="${zipName}"`);

    // Criar arquivo ZIP
    const archive = archiver('zip', { zlib: { level: 9 } });

    // Lidar com erros
    archive.on('error', (err) => {
        res.status(500).send('Erro ao criar ZIP');
    });

    // Pipe para a response
    archive.pipe(res);

    // Adicionar pasta ao ZIP
    archive.directory(folderPath, false);

    // Finalizar
    archive.finalize();
});

app.listen(port, () => {
    console.log(`Servidor rodando em http://localhost:${port}`);
});