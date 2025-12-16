# Blueprint de la Aplicación Trivi App

## Visión General

Trivi App es una aplicación de trivia móvil moderna y atractiva desarrollada en Flutter. El objetivo es ofrecer a los usuarios una experiencia de juego divertida y educativa, con una interfaz limpia y animaciones fluidas. La app se conecta a Firebase para la autenticación de usuarios y, en una futura versión, para la generación de preguntas mediante IA con Gemini.

## Diseño y Estilo

La aplicación sigue los principios de Material Design 3, asegurando una experiencia de usuario coherente y moderna.

- **Paleta de Colores:** Se utiliza un esquema de colores generado a partir de un color semilla (`Colors.deepPurple`), lo que proporciona una apariencia cohesiva y soporte para temas claro y oscuro.
- **Tipografía:** Se emplea el paquete `google_fonts` para una tipografía rica y legible, con `Oswald` para títulos y `Roboto` para el cuerpo del texto, creando un contraste visual claro.
- **Componentes:** Los widgets como `AppBar` y `ElevatedButton` están estilizados de forma centralizada en el `ThemeData` para garantizar la consistencia en toda la aplicación.
- **Iconografía:** Se utilizan iconos de Material (como el logo de Google y los iconos de cambio de tema) para mejorar la usabilidad.
- **Layout:** Los diseños son responsivos y centrados, utilizando `SingleChildScrollView` para evitar problemas de desbordamiento en pantallas más pequeñas.

## Características Implementadas

### Versión 1.0 (Actual)

1.  **Autenticación de Usuarios con Firebase:**
    *   **Inicio de Sesión y Registro:** Los usuarios pueden crear una cuenta o iniciar sesión utilizando su correo electrónico y contraseña.
    *   **Inicio de Sesión con Google:** Se ofrece una opción de inicio de sesión de un solo toque a través de Google, lo que simplifica el proceso de onboarding.
    *   **Gestión de Sesión:** La aplicación gestiona automáticamente el estado de la sesión del usuario, redirigiéndolo a la pantalla de inicio si ya ha iniciado sesión, o a la pantalla de login si no lo ha hecho.
    *   **Cierre de Sesión:** Los usuarios pueden cerrar sesión fácilmente desde la pantalla de inicio.

2.  **Juego de Trivia (Versión con Preguntas de Prueba):**
    *   **Preguntas Locales:** Para garantizar la funcionalidad inmediata y evitar los problemas con la API de IA, el juego utiliza una lista predefinida y aleatoria de preguntas de trivia almacenadas directamente en el código.
    *   **Flujo del Juego:** El usuario inicia el juego, responde a una serie de preguntas y, al final, se le presenta una pantalla con su puntuación final.
    *   **Interfaz del Juego:**
        *   Muestra la pregunta actual y el progreso (p. ej., "Pregunta 1/5").
        *   Las opciones de respuesta se presentan como botones.
        *   Se proporciona retroalimentación visual instantánea: las respuestas correctas se marcan en verde y las incorrectas en rojo.
        *   Transición automática a la siguiente pregunta después de un breve retardo.

3.  **Navegación y Arquitectura:**
    *   **Gestión de Estado:** Se utiliza el paquete `provider` para gestionar el estado del tema (claro/oscuro).
    *   **Estructura de Archivos:** El código está organizado por características (auth, game, home) en carpetas separadas dentro de `lib/screens`, lo que mejora la mantenibilidad.
    *   **Enrutamiento:** Se utiliza `MaterialPageRoute` para la navegación básica entre pantallas.

## Plan para la Versión Actual (Simplificado)

El objetivo actual es consolidar una versión funcional y estable de la aplicación con las características principales.

- **[✓] Paso 1: Eliminar la dependencia `firebase_ai`**
  - Se ha ejecutado `flutter pub remove firebase_ai` para limpiar el proyecto de dependencias no utilizadas y problemáticas.

- **[✓] Paso 2: Implementar preguntas de prueba locales**
  - Se ha modificado `lib/screens/game/game_screen.dart` para eliminar toda la lógica de la IA.
  - Se ha creado una lista de objetos `TriviaQuestion` dentro del archivo para servir como fuente de preguntas.
  - La lógica del juego ahora lee de esta lista local, asegurando un funcionamiento rápido y sin errores.

- **[✓] Paso 3: Ajustar la interfaz de usuario del juego**
  - La pantalla del juego ahora refleja el progreso basado en el número total de preguntas locales.
  - La pantalla de resultados (`ResultsScreen`) recibe la puntuación y el total de preguntas para mostrar un resumen final.

- **[ ] Paso 4 (Futuro): Re-integración de la IA con Gemini**
  - Una vez que la aplicación base sea completamente estable y se resuelvan los posibles conflictos de dependencias, se volverá a intentar la integración de `firebase_ai`.
  - Se creará una rama de desarrollo separada para experimentar con la API de Gemini, asegurando que no afecte a la versión estable de la aplicación.
