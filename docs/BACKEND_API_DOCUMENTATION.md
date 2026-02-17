# API Documentation - Microservicio Zoque

## Información General

- **Nombre**: ms-app-zoque
- **Versión**: 0.0.1
- **Framework**: NestJS
- **Base de Datos**: PostgreSQL
- **Puerto por defecto**: 3000
- **Base URL**: `https://ms-app-zoque-js.vercel.app/` URL de producción en Vercel

## Autenticación

La API utiliza autenticación basada en Google OAuth2. La mayoría de los endpoints están protegidos y requieren un token JWT válido en el header de autorización.

### Headers requeridos (endpoints protegidos):

```
Authorization: Bearer <token>
```

### Roles de Usuario:

- **1**: Administrador (acceso completo)
- **2**: Usuario Normal (acceso limitado)

---

## Endpoints

### 1. Root

#### GET `/`

Endpoint de bienvenida/health check.

**Autenticación**: No requerida

**Response**:

```json
"Hello World!"
```

---

### 2. Autenticación (`/auth`)

#### POST `/auth/verify`

Verifica un token de Google OAuth2 y retorna la información del usuario.

**Autenticación**: No requerida (público)

**Request Body**:

```json
{
  "token": "string (Google ID Token)"
}
```

**Response Success (Usuario en BD)**:

```json
{
  "id": 1,
  "email": "usuario@example.com",
  "username": "usuario",
  "idRole": 1
}
```

**Response Success (Usuario NO en BD - Guest)**:

```json
{
  "email": "usuario@example.com",
  "username": "usuario",
  "idRole": 2
}
```

**Response Error (400)**:

```json
{
  "statusCode": 400,
  "message": "Token is required"
}
```

**Response Error (401)**:

```json
{
  "statusCode": 401,
  "message": "Invalid token format"
}
```

---

### 3. Menú (`/menu`)

#### GET `/menu`

Obtiene los items del menú filtrados según el rol del usuario autenticado.

**Autenticación**: Requerida

**Query Parameters**: Ninguno

**Response Success (200)**:

```json
[
  {
    "id": "home",
    "label": "Inicio",
    "icon": "home_icon.svg",
    "activeIcon": "home_icon_active.svg",
    "route": "/home",
    "requiredRoleId": null,
    "order": 1
  },
  {
    "id": "dictionary",
    "label": "Diccionario",
    "icon": "dictionary_icon.svg",
    "activeIcon": "dictionary_icon_active.svg",
    "route": "/dictionary",
    "requiredRoleId": null,
    "order": 2
  }
]
```

**Notas**:

- Los items con `requiredRoleId: null` son visibles para todos
- Los administradores (idRole: 1) ven todos los items
- Los usuarios normales solo ven items con `requiredRoleId: null` o `requiredRoleId: 2`

---

### 4. Diccionario (`/dictionary`)

#### GET `/dictionary`

Obtiene todas las palabras del diccionario con paginación y búsqueda.

**Autenticación**: No requerida (público)

**Query Parameters**:

- `page` (number, opcional, default: 1): Número de página
- `limit` (number, opcional, default: 10): Elementos por página
- `search` (string, opcional): Término de búsqueda (busca en wordZoque y wordSpanish)

**Response Success (200)**:

```json
{
  "data": [
    {
      "id": "uuid-string",
      "wordZoque": "nähä",
      "wordSpanish": "agua",
      "pronunciation": "na-ha",
      "category": "sustantivo",
      "examples": [
        {
          "zoque": "Nähä yomo",
          "spanish": "El agua está fría"
        }
      ],
      "audioUrl": "https://example.com/audio/naha.mp3"
    }
  ],
  "total": 100,
  "page": 1,
  "limit": 10,
  "totalPages": 10
}
```

#### GET `/dictionary/:id`

Obtiene una palabra específica del diccionario por ID.

**Autenticación**: No requerida (público)

**Path Parameters**:

- `id` (string, UUID): ID de la palabra

**Response Success (200)**:

```json
{
  "id": "uuid-string",
  "wordZoque": "nähä",
  "wordSpanish": "agua",
  "pronunciation": "na-ha",
  "category": "sustantivo",
  "examples": [
    {
      "zoque": "Nähä yomo",
      "spanish": "El agua está fría"
    }
  ],
  "audioUrl": "https://example.com/audio/naha.mp3"
}
```

**Response Error (404)**:

```json
{
  "statusCode": 404,
  "message": "Word not found"
}
```

#### POST `/dictionary`

Crea una nueva palabra en el diccionario.

**Autenticación**: Requerida (Solo Admin - Role 1)

**Request Body**:

```json
{
  "wordZoque": "nähä",
  "wordSpanish": "agua",
  "pronunciation": "na-ha",
  "category": "sustantivo",
  "examples": [
    {
      "zoque": "Nähä yomo",
      "spanish": "El agua está fría"
    }
  ],
  "audioUrl": "https://example.com/audio/naha.mp3"
}
```

**Response Success (201)**:

```json
{
  "id": "uuid-string",
  "wordZoque": "nähä",
  "wordSpanish": "agua",
  "pronunciation": "na-ha",
  "category": "sustantivo",
  "examples": [
    {
      "zoque": "Nähä yomo",
      "spanish": "El agua está fría"
    }
  ],
  "audioUrl": "https://example.com/audio/naha.mp3"
}
```

#### PUT `/dictionary/:id`

Actualiza una palabra existente del diccionario.

**Autenticación**: Requerida (Solo Admin - Role 1)

**Path Parameters**:

- `id` (string, UUID): ID de la palabra

**Request Body** (todos los campos opcionales):

```json
{
  "wordZoque": "nähä",
  "wordSpanish": "agua",
  "pronunciation": "na-ha",
  "category": "sustantivo",
  "examples": [
    {
      "zoque": "Nähä yomo",
      "spanish": "El agua está fría"
    }
  ],
  "audioUrl": "https://example.com/audio/naha.mp3"
}
```

**Response Success (200)**:

```json
{
  "id": "uuid-string",
  "wordZoque": "nähä",
  "wordSpanish": "agua",
  "pronunciation": "na-ha",
  "category": "sustantivo",
  "examples": [
    {
      "zoque": "Nähä yomo",
      "spanish": "El agua está fría"
    }
  ],
  "audioUrl": "https://example.com/audio/naha.mp3"
}
```

#### DELETE `/dictionary/:id`

Elimina una palabra del diccionario.

**Autenticación**: Requerida (Solo Admin - Role 1)

**Path Parameters**:

- `id` (string, UUID): ID de la palabra

**Response Success (200)**:

```json
{
  "message": "Word deleted successfully"
}
```

---

### 5. Noticias (`/news`)

#### GET `/news`

Obtiene todas las noticias con paginación y búsqueda.

**Autenticación**: No requerida (público)

**Query Parameters**:

- `page` (number, opcional, default: 1): Número de página
- `limit` (number, opcional, default: 10): Elementos por página
- `search` (string, opcional): Término de búsqueda (busca en títulos y descripción)

**Response Success (200)**:

```json
{
  "data": [
    {
      "id": "news-001",
      "titleSpanish": "Celebración del Día de la Lengua Zoque",
      "titleZoque": "Título en Zoque",
      "description": "Descripción de la noticia...",
      "youtubeVideoId": "dQw4w9WgXcQ",
      "thumbnailUrl": "https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg",
      "publishedDate": "2024-01-15T00:00:00.000Z",
      "category": "cultura"
    }
  ],
  "total": 50,
  "page": 1,
  "limit": 10,
  "totalPages": 5
}
```

#### GET `/news/:id`

Obtiene una noticia específica por ID.

**Autenticación**: No requerida (público)

**Path Parameters**:

- `id` (string): ID de la noticia

**Response Success (200)**:

```json
{
  "id": "news-001",
  "titleSpanish": "Celebración del Día de la Lengua Zoque",
  "titleZoque": "Título en Zoque",
  "description": "Descripción de la noticia...",
  "youtubeVideoId": "dQw4w9WgXcQ",
  "thumbnailUrl": "https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg",
  "publishedDate": "2024-01-15T00:00:00.000Z",
  "category": "cultura"
}
```

#### POST `/news`

Crea una nueva noticia.

**Autenticación**: Requerida (Solo Admin - Role 1)

**Request Body**:

```json
{
  "id": "news-002",
  "titleSpanish": "Nueva noticia",
  "titleZoque": "Título en Zoque",
  "description": "Descripción de la noticia...",
  "youtubeVideoId": "dQw4w9WgXcQ",
  "thumbnailUrl": "https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg",
  "publishedDate": "2024-01-15T00:00:00.000Z",
  "category": "cultura"
}
```

**Response Success (201)**:

```json
{
  "id": "news-002",
  "titleSpanish": "Nueva noticia",
  "titleZoque": "Título en Zoque",
  "description": "Descripción de la noticia...",
  "youtubeVideoId": "dQw4w9WgXcQ",
  "thumbnailUrl": "https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg",
  "publishedDate": "2024-01-15T00:00:00.000Z",
  "category": "cultura"
}
```

#### PUT `/news/:id`

Actualiza una noticia existente.

**Autenticación**: Requerida (Solo Admin - Role 1)

**Path Parameters**:

- `id` (string): ID de la noticia

**Request Body** (todos los campos opcionales):

```json
{
  "titleSpanish": "Título actualizado",
  "titleZoque": "Título en Zoque actualizado",
  "description": "Nueva descripción...",
  "youtubeVideoId": "newVideoId",
  "thumbnailUrl": "https://new-url.com/image.jpg",
  "publishedDate": "2024-01-20T00:00:00.000Z",
  "category": "educación"
}
```

**Response Success (200)**:

```json
{
  "id": "news-002",
  "titleSpanish": "Título actualizado",
  "titleZoque": "Título en Zoque actualizado",
  "description": "Nueva descripción...",
  "youtubeVideoId": "newVideoId",
  "thumbnailUrl": "https://new-url.com/image.jpg",
  "publishedDate": "2024-01-20T00:00:00.000Z",
  "category": "educación"
}
```

#### DELETE `/news/:id`

Elimina una noticia.

**Autenticación**: Requerida (Solo Admin - Role 1)

**Path Parameters**:

- `id` (string): ID de la noticia

**Response Success (200)**:

```json
{
  "message": "News deleted successfully"
}
```

---

### 6. Enseñanza/Módulos (`/teaching`)

#### GET `/teaching`

Obtiene todos los módulos de enseñanza con paginación y búsqueda.

**Autenticación**: No requerida (público)

**Query Parameters**:

- `page` (number, opcional, default: 1): Número de página
- `limit` (number, opcional, default: 10): Elementos por página
- `search` (string, opcional): Término de búsqueda (busca en título y descripción)

**Response Success (200)**:

```json
{
  "data": [
    {
      "id": "uuid-string",
      "title": "Introducción al Zoque",
      "titleZoque": "Título en Zoque",
      "description": "Aprende los fundamentos básicos del idioma Zoque",
      "imageUrl": "https://example.com/module-image.jpg",
      "level": "principiante",
      "lessons": [
        {
          "id": "lesson-uuid",
          "title": "Lección 1: Saludos",
          "content": "Contenido de la lección...",
          "duration": "15 min",
          "type": "video",
          "vocabulary": [
            {
              "word": "nähä",
              "translation": "agua"
            }
          ],
          "examples": [
            {
              "zoque": "Ejemplo en zoque",
              "spanish": "Ejemplo en español"
            }
          ],
          "exercises": [
            {
              "question": "¿Cómo se dice agua en Zoque?",
              "options": ["nähä", "yomo", "tama"],
              "correctAnswer": 0
            }
          ]
        }
      ]
    }
  ],
  "total": 20,
  "page": 1,
  "limit": 10,
  "totalPages": 2
}
```

#### GET `/teaching/:id`

Obtiene un módulo específico con todas sus lecciones.

**Autenticación**: No requerida (público)

**Path Parameters**:

- `id` (string, UUID): ID del módulo

**Response Success (200)**:

```json
{
  "id": "uuid-string",
  "title": "Introducción al Zoque",
  "titleZoque": "Título en Zoque",
  "description": "Aprende los fundamentos básicos del idioma Zoque",
  "imageUrl": "https://example.com/module-image.jpg",
  "level": "principiante",
  "lessons": [
    {
      "id": "lesson-uuid",
      "title": "Lección 1: Saludos",
      "content": "Contenido de la lección...",
      "duration": "15 min",
      "type": "video",
      "vocabulary": [],
      "examples": [],
      "exercises": []
    }
  ]
}
```

#### GET `/teaching/lesson/:id`

Obtiene una lección específica por ID.

**Autenticación**: No requerida (público)

**Path Parameters**:

- `id` (string, UUID): ID de la lección

**Response Success (200)**:

```json
{
  "id": "lesson-uuid",
  "title": "Lección 1: Saludos",
  "content": "Contenido completo de la lección...",
  "duration": "15 min",
  "type": "video",
  "vocabulary": [
    {
      "word": "nähä",
      "translation": "agua",
      "pronunciation": "na-ha"
    }
  ],
  "examples": [
    {
      "zoque": "Nähä yomo",
      "spanish": "El agua está fría"
    }
  ],
  "exercises": [
    {
      "question": "¿Cómo se dice agua en Zoque?",
      "options": ["nähä", "yomo", "tama"],
      "correctAnswer": 0
    }
  ]
}
```

#### POST `/teaching/module`

Crea un nuevo módulo de enseñanza.

**Autenticación**: Requerida (Solo Admin - Role 1)

**Request Body**:

```json
{
  "title": "Nuevo Módulo",
  "titleZoque": "Título en Zoque",
  "description": "Descripción del módulo",
  "imageUrl": "https://example.com/image.jpg",
  "level": "intermedio"
}
```

**Response Success (201)**:

```json
{
  "id": "new-uuid",
  "title": "Nuevo Módulo",
  "titleZoque": "Título en Zoque",
  "description": "Descripción del módulo",
  "imageUrl": "https://example.com/image.jpg",
  "level": "intermedio",
  "lessons": []
}
```

#### PUT `/teaching/module/:id`

Actualiza un módulo existente.

**Autenticación**: Requerida (Solo Admin - Role 1)

**Path Parameters**:

- `id` (string, UUID): ID del módulo

**Request Body** (todos los campos opcionales):

```json
{
  "title": "Módulo Actualizado",
  "titleZoque": "Título actualizado",
  "description": "Nueva descripción",
  "imageUrl": "https://example.com/new-image.jpg",
  "level": "avanzado"
}
```

**Response Success (200)**:

```json
{
  "id": "uuid",
  "title": "Módulo Actualizado",
  "titleZoque": "Título actualizado",
  "description": "Nueva descripción",
  "imageUrl": "https://example.com/new-image.jpg",
  "level": "avanzado",
  "lessons": []
}
```

#### DELETE `/teaching/module/:id`

Elimina un módulo y todas sus lecciones.

**Autenticación**: Requerida (Solo Admin - Role 1)

**Path Parameters**:

- `id` (string, UUID): ID del módulo

**Response Success (200)**:

```json
{
  "message": "Module deleted successfully"
}
```

#### POST `/teaching/module/:moduleId/lesson`

Crea una nueva lección dentro de un módulo.

**Autenticación**: Requerida (Solo Admin - Role 1)

**Path Parameters**:

- `moduleId` (string, UUID): ID del módulo padre

**Request Body**:

```json
{
  "title": "Nueva Lección",
  "content": "Contenido de la lección...",
  "duration": "20 min",
  "type": "text",
  "vocabulary": [
    {
      "word": "palabra",
      "translation": "traducción"
    }
  ],
  "examples": [
    {
      "zoque": "Ejemplo",
      "spanish": "Traducción"
    }
  ],
  "exercises": [
    {
      "question": "Pregunta",
      "options": ["A", "B", "C"],
      "correctAnswer": 0
    }
  ]
}
```

**Response Success (201)**:

```json
{
  "id": "lesson-uuid",
  "title": "Nueva Lección",
  "content": "Contenido de la lección...",
  "duration": "20 min",
  "type": "text",
  "vocabulary": [],
  "examples": [],
  "exercises": []
}
```

#### PUT `/teaching/lesson/:id`

Actualiza una lección existente.

**Autenticación**: Requerida (Solo Admin - Role 1)

**Path Parameters**:

- `id` (string, UUID): ID de la lección

**Request Body** (todos los campos opcionales):

```json
{
  "title": "Lección Actualizada",
  "content": "Nuevo contenido...",
  "duration": "25 min",
  "type": "video",
  "vocabulary": [],
  "examples": [],
  "exercises": []
}
```

**Response Success (200)**:

```json
{
  "id": "lesson-uuid",
  "title": "Lección Actualizada",
  "content": "Nuevo contenido...",
  "duration": "25 min",
  "type": "video",
  "vocabulary": [],
  "examples": [],
  "exercises": []
}
```

#### DELETE `/teaching/lesson/:id`

Elimina una lección.

**Autenticación**: Requerida (Solo Admin - Role 1)

**Path Parameters**:

- `id` (string, UUID): ID de la lección

**Response Success (200)**:

```json
{
  "message": "Lesson deleted successfully"
}
```

#### POST `/teaching/seed`

Endpoint para poblar la base de datos con datos de prueba.

**Autenticación**: Requerida

**Request Body**:

```json
[
  {
    "title": "Módulo 1",
    "titleZoque": "Título Zoque",
    "description": "Descripción",
    "imageUrl": "url",
    "level": "principiante",
    "lessons": []
  }
]
```

**Response Success (201)**:

```json
{
  "message": "Data seeded successfully",
  "count": 5
}
```

---

## Códigos de Estado HTTP

- **200 OK**: Solicitud exitosa
- **201 Created**: Recurso creado exitosamente
- **400 Bad Request**: Solicitud inválida o parámetros faltantes
- **401 Unauthorized**: Token inválido o faltante
- **403 Forbidden**: Sin permisos suficientes (rol inadecuado)
- **404 Not Found**: Recurso no encontrado
- **500 Internal Server Error**: Error del servidor

---

## Modelos de Datos

### User

```typescript
{
  id: number;
  email: string;
  username: string;
  idRole: number; // 1 = Admin, 2 = Normal
}
```

### DictionaryWord

```typescript
{
  id: string; // UUID
  wordZoque: string;
  wordSpanish: string;
  pronunciation: string;
  category: string;
  examples: Array<{
    zoque: string;
    spanish: string;
  }>;
  audioUrl: string | null;
}
```

### NewsItem

```typescript
{
  id: string;
  titleSpanish: string;
  titleZoque: string;
  description: string;
  youtubeVideoId: string;
  thumbnailUrl: string | null;
  publishedDate: Date;
  category: string;
}
```

### MenuItem

```typescript
{
  id: string;
  label: string;
  icon: string;
  activeIcon: string;
  route: string;
  requiredRoleId: number | null;
  order: number;
}
```

### TeachingModule

```typescript
{
  id: string; // UUID
  title: string;
  titleZoque: string;
  description: string;
  imageUrl: string;
  level: string;
  lessons: Lesson[];
}
```

### Lesson

```typescript
{
  id: string; // UUID
  title: string;
  content: string;
  duration: string;
  type: string;
  vocabulary: any[];
  examples: any[];
  exercises: any[];
}
```

---

## Notas Adicionales

### CORS

La API tiene CORS habilitado para todas las solicitudes.

### Paginación

Los endpoints que soportan paginación retornan el siguiente formato:

```json
{
  "data": [...],
  "total": number,
  "page": number,
  "limit": number,
  "totalPages": number
}
```

### Búsqueda

Los endpoints con parámetro `search` realizan búsquedas case-insensitive en los campos de texto relevantes.

### Decoradores de Seguridad

- `@Public()`: Endpoint accesible sin autenticación
- `@Roles(1)`: Solo accesible para administradores
- Sin decorador: Requiere autenticación pero accesible para cualquier usuario autenticado
