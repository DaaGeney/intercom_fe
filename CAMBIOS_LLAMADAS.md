# Cambios en Flujo de Llamadas

## Problemas Solucionados

### 1. ❌ Problema: Pantalla "Call Ended" sin forma de regresar
**Solución:** `CallScreen` ahora detecta cuando `call == null` y automáticamente regresa usando `context.pop()`

```dart
// lib/ui/screens/call_screen.dart
if (call == null) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (context.mounted) {
      context.pop();  // Regresar automáticamente
    }
  });
  return Scaffold(...); // Mostrar loading mientras regresa
}
```

---

### 2. ❌ Problema: Llamada entrante mostraba la misma pantalla que llamada saliente
**Solución:** Creada nueva pantalla `IncomingCallScreen` con botones Aceptar/Rechazar

---

## Flujo Actualizado de Llamadas

### Llamada Saliente (Usuario A llama a B)

```
Usuario A presiona "Llamar" a Usuario B
  ↓
POST /calls → Backend retorna token y url
  ↓
CallsController actualiza state
  ↓
Navega a: /call/{id} → CallScreen
  ↓
CallScreen se conecta automáticamente a LiveKit
  ↓
Usuario A escucha audio
```

**Pantalla:** `CallScreen` con botones de controles (mute, speaker, colgar)

---

### Llamada Entrante (Usuario B recibe llamada)

```
Backend emite: call.started
  ↓
CallsController actualiza state
  ↓
UsersScreen detecta: next.toUserId == currentUser.id
  ↓
Navega a: /incoming-call/{id} → IncomingCallScreen
  ↓
IncomingCallScreen muestra:
  - Avatar grande del que llama
  - Nombre del que llama
  - Botón RECHAZAR (rojo)
  - Botón ACEPTAR (verde)
```

#### Si RECHAZA:
```
Presiona "Rechazar"
  ↓
POST /calls/{id}/end
  ↓
Backend emite: call.ended
  ↓
CallsController: state = null
  ↓
IncomingCallScreen detecta call == null
  ↓
Regresa automáticamente con context.pop()
```

#### Si ACEPTA:
```
Presiona "Aceptar"
  ↓
Navega a: /call/{id} con context.pushReplacement()
  ↓
CallScreen obtiene token con POST /livekit/token
  ↓
CallScreen se conecta a LiveKit
  ↓
Usuario B escucha audio
```

---

### Cuando Termina la Llamada (Cualquiera cuelga)

```
Usuario presiona "Colgar"
  ↓
POST /calls/{id}/end
  ↓
Backend emite: call.ended (a todos)
  ↓
CallsController: state = null (en ambos clientes)
  ↓
CallScreen detecta call == null
  ↓
Regresa automáticamente con context.pop()
  ↓
Usuario vuelve a UsersScreen
```

---

## Archivos Modificados

### 1. `lib/ui/screens/incoming_call_screen.dart` (NUEVO)
Pantalla de llamada entrante con:
- Avatar grande del que llama
- Nombre del que llama
- "Llamada de voz" con icono
- Banner "CIFRADO DE EXTREMO A EXTREMO"
- Botón RECHAZAR (rojo, llama a `endCall`)
- Botón ACEPTAR (verde, navega a `CallScreen`)
- Auto-regreso si la llamada termina mientras está en esta pantalla

### 2. `lib/ui/screens/call_screen.dart`
**Cambio:**
```dart
// ANTES: Mostraba "Call Ended" sin forma de regresar
if (call == null) {
  return Scaffold(
    body: const Center(child: Text('Call Ended')),
  );
}

// AHORA: Regresa automáticamente
if (call == null) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (context.mounted) {
      context.pop();
    }
  });
  return Scaffold(
    body: const Center(child: CircularProgressIndicator()),
  );
}
```

### 3. `lib/ui/screens/users_screen.dart`
**Cambio:**
```dart
// ANTES: Navegaba directo a CallScreen
context.push('/call/${next.id}');

// AHORA: Navega a IncomingCallScreen
context.push('/incoming-call/${next.id}');
```

### 4. `lib/main.dart`
**Cambio:** Agregada nueva ruta
```dart
GoRoute(
  path: '/incoming-call/:id',
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    return IncomingCallScreen(callId: id);
  },
),
```

---

## Diagrama de Navegación

```
UsersScreen (lista de usuarios)
    │
    ├─ [Usuario INICIA llamada] → CallScreen (conectado)
    │                                   │
    │                                   └─ [Cuelga] → UsersScreen
    │
    └─ [Usuario RECIBE llamada] → IncomingCallScreen
                                        │
                                        ├─ [Rechaza] → UsersScreen
                                        │
                                        └─ [Acepta] → CallScreen (conectado)
                                                           │
                                                           └─ [Termina] → UsersScreen
```

---

## Validaciones Implementadas

✅ Llamadas entrantes muestran pantalla diferente
✅ Pantalla de llamada entrante tiene botones Aceptar/Rechazar
✅ Al rechazar, termina la llamada y regresa
✅ Al aceptar, navega a CallScreen normal
✅ Cuando termina la llamada, regresa automáticamente
✅ No se queda atascado en "Call Ended"
✅ Si la llamada termina mientras está en IncomingCallScreen, regresa automáticamente

---

## Próximas Mejoras Sugeridas (Opcional)

- [ ] Sonido de timbre para llamadas entrantes
- [ ] Vibración al recibir llamada
- [ ] Notificación push si la app está en background
- [ ] Tiempo de espera para auto-rechazar llamada no contestada

