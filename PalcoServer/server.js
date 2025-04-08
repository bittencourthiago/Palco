const WebSocket = require('ws');

const wss = new WebSocket.Server({ port: 8080 });

let chatRooms = {};  // Armazena salas de chat com seus clientes conectados

wss.on('connection', (ws, req) => {
    const urlParams = new URLSearchParams(req.url.split('?')[1]);
    const roomId = urlParams.get('room');
    
    if (!roomId) {
        ws.close();
        return;
    }

    // Criação de uma nova sala ou adição de um cliente na sala existente
    if (!chatRooms[roomId]) {
        chatRooms[roomId] = new Set();
    }

    chatRooms[roomId].add(ws);
    console.log(`🔗 Usuário conectado na sala ${roomId}`);
    
    // Quando o cliente envia uma mensagem
    ws.on('message', (message) => {
        console.log(`📩 Mensagem recebida na sala ${roomId}: ${message}`);
        
        // Enviar a mensagem para todos os clientes conectados na sala, exceto o remetente
        chatRooms[roomId].forEach(client => {
            if (client !== ws) {
                client.send(message);
                console.log(`📤 Mensagem enviada para cliente`);
            }
        });
    });

    // Quando o cliente se desconectar
    ws.on('close', () => {
        chatRooms[roomId].delete(ws);
        if (chatRooms[roomId].size === 0) {
            delete chatRooms[roomId];  // Remove a sala se estiver vazia
        }
        console.log(`⚠️ Usuário desconectado da sala ${roomId}`);
    });
});

console.log('🚀 Servidor WebSocket rodando na porta 8080...');
