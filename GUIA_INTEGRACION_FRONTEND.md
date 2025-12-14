# Guía de Integración Backend (Implementado)

Este documento confirma la implementación final de los servicios de backend para la integración con el frontend, específicamente cubriendo Socket.IO y la API REST.

**Estado:** ✅ Implementado y Disponible

---

## 1. Conexión Socket.IO

El servidor Socket.IO está activo y escuchando en el mismo puerto que la API REST.

*   **URL Base:** `https://h0jpg5qd-3000.use2.devtunnels.ms` (o tu URL local)
*   **Transports:** `websocket`, `polling`
*   **CORS:** Habilitado para todos los orígenes (`*`).

### Ejemplo de Conexión
```javascript
const socket = io('https://h0jpg5qd-3000.use2.devtunnels.ms', {
  transports: ['websocket', 'polling']
});

socket.on('connect', () => {
  console.log('Conectado al backend:', socket.id);
});
```

---

## 2. Eventos Emitidos (Server -> Client)

El backend emite los siguientes eventos a **todos** los clientes conectados (broadcast).

### `call.started`
Se emite cuando se crea una llamada exitosamente (`POST /calls`).

```json
{
  "data": {
    "id": "uuid",
    "callId": "uuid",
    "fromUserId": "user-uuid",
    "toUserId": "user-uuid",
    "status": "initiated",
    "roomName": "uuid",
    "startTime": "ISO-Date"
  }
}
```

### `call.ended`
Se emite cuando una llamada finaliza (`POST /calls/:id/end`).

```json
{
  "data": {
    "callId": "uuid"
  }
}
```

### `user.registered`
Se emite cuando se registra un nuevo usuario (`POST /users`).

```json
{
  "data": {
    "id": "uuid",
    "name": "Nombre Usuario"
  }
}
```

### `room.created`
Se emite cuando se crea una sala (`POST /rooms`).

```json
{
  "data": {
    "id": "uuid",
    "name": "Nombre Sala",
    "roomName": "uuid",
    "participants": []
  }
}
```

### `room.joined`
Se emite cuando un usuario se une a una sala (`POST /rooms/:id/join`).

```json
{
  "data": {
    "roomId": "room-uuid",
    "userId": "user-uuid"
  }
}
```

---

## 3. Endpoints REST Clave

Estos endpoints disparan los eventos mencionados arriba.

| Método | Endpoint | Acción | Evento Disparado |
| :--- | :--- | :--- | :--- |
| `POST` | `/users` | Crear Usuario | `user.registered` |
| `POST` | `/calls` | Iniciar Llamada | `call.started` |
| `POST` | `/calls/:id/end` | Terminar Llamada | `call.ended` |
| `POST` | `/rooms` | Crear Sala | `room.created` |
| `POST` | `/rooms/:id/join` | Unirse a Sala | `room.joined` |

---

## 4. Uso de URL de LiveKit (Dinámica)

El backend gestiona la URL del servidor LiveKit y la retorna dinámicamente.

**⚠️ IMPORTANTE PARA FRONTEND:**
*   **NO hardcodear** la URL de LiveKit (`wss://...`) en la aplicación móvil/web.
*   **SIEMPRE usar la propiedad `url`** que viene en la respuesta JSON de los endpoints que retornan tokens.

### Endpoints que retornan `url` y `token`:
*   `POST /calls` (para el que llama)
*   `POST /livekit/token` (para el que recibe)
*   `POST /rooms/:id/join` (para unirse a sala)

**Ejemplo de respuesta:**
```json
{
  "token": "eyJhbGc...",
  "url": "wss://h0jpg5qd-7880.use2.devtunnels.ms/", 
  ...
}
```

El cliente LiveKit debe inicializarse usando estos valores:
```javascript
// Ejemplo conceptual
LiveKitClient.connect(response.url, response.token);
```

---

## Notas Adicionales

1.  **Tokens en Eventos:** Los eventos de Socket.IO **NO** contienen tokens de LiveKit por seguridad.
2.  **Flujo de Llamada Entrante:**
    *   Al recibir `call.started`, verifica si `toUserId` coincide con el usuario actual.
    *   Si coincide, muestra la pantalla de llamada entrante.
    *   Para contestar, llama a `POST /livekit/token` para obtener tus credenciales (`token` y `url`) para conectar a LiveKit.
