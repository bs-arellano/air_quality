# Calidad del Aire: Aplicación para Monitoreo Personalizado

En el contexto de crecientes inquietudes acerca de la influencia directa de la exposición a partículas contaminantes en el aire en la salud humana, se aborda la necesidad de una solución innovadora y personalizada en este artículo. Diversas investigaciones han resaltado las asociaciones entre contaminantes atmosféricos y riesgos de salud específicos, que van desde problemas respiratorios hasta tumores cerebrales benignos y la incidencia de tuberculosis. Asimismo, se ha destacado la variabilidad inter e intra-individual en los riesgos de salud, así como los desafíos asociados con el cumplimiento de las directrices de calidad del aire.

## Descripción del Proyecto

Para abordar esta problemática, se propone el diseño y desarrollo de una aplicación móvil funcional que, haciendo uso del sistema de posicionamiento global (GPS) del dispositivo y consumiendo diversas interfaces de programación de aplicaciones (API), informa en tiempo real el nivel de exposición del usuario a material particulado PM2.5 y PM10. Además de proporcionar alertas instantáneas, la aplicación permite a los usuarios realizar un seguimiento detallado de su exposición a lo largo del tiempo, facilitando una comprensión personalizada de los riesgos ambientales. Esta solución no solo busca informar, sino también empoderar a los individuos para que tomen decisiones conscientes y adopten medidas proactivas en beneficio de su salud respiratoria y ambiental.

## Características Principales

- **Monitoreo en Tiempo Real:** La aplicación ofrece información en tiempo real sobre los niveles de material particulado PM2.5 y PM10 en la ubicación actual del usuario.
- **Alertas Instantáneas:** Se proporcionan alertas instantáneas cuando los niveles de contaminación exceden los umbrales seguros, permitiendo a los usuarios tomar medidas preventivas.
- **Seguimiento Histórico:** Los usuarios pueden realizar un seguimiento detallado de su exposición a lo largo del tiempo, lo que facilita una comprensión personalizada de los riesgos ambientales.
- **Interfaz Intuitiva:** La interfaz de usuario es fácil de usar y permite una navegación fluida para acceder a información relevante de manera rápida y sencilla.

## Despliegue de la API

Para desplegar la API en tu entorno local, sigue estos pasos:

1. **Accede a la Carpeta Backend:**
   ```bash
   cd backend
   ```

2. **Instala las Dependencias:**
   ```bash
   npm install
   ```

3. **Ejecuta el Servidor de Desarrollo:**
   ```bash
   npm run dev
   ```

Una vez ejecutados estos pasos, la API estará en funcionamiento y podrás comenzar a utilizarla para obtener datos de calidad del aire y otros servicios proporcionados por la aplicación.

Recuerda asegurarte de que los puertos necesarios estén disponibles y de que no haya conflictos con otros servicios en ejecución en tu sistema.

## Cliente

El cliente de la aplicación se encuentra en la carpeta `air_quality`, desarrollado en Flutter. Sigue los siguientes pasos para ejecutar el cliente:

1. **Verificar la Instalación de Flutter:**
   Antes de comenzar, asegúrate de tener Flutter instalado en tu sistema. Puedes verificar si Flutter está instalado ejecutando el siguiente comando en tu terminal:
   ```bash
   flutter doctor
   ```
   Si Flutter no está instalado, sigue las instrucciones en [https://docs.flutter.dev/get-started/install](https://docs.flutter.dev/get-started/install) para instalarlo.

2. **Listar Dispositivos Disponibles:**
   Una vez que Flutter esté instalado, ejecuta el siguiente comando para listar los dispositivos disponibles en los que puedes probar la aplicación:
   ```bash
   flutter devices
   ```

3. **Ejecutar la Aplicación:**
   Finalmente, para ejecutar la aplicación en un dispositivo o emulador seleccionado, utiliza el siguiente comando:
   ```bash
   flutter run
   ```
   Esto lanzará la aplicación en el dispositivo seleccionado y podrás comenzar a probarla y utilizarla para monitorear la calidad del aire en tiempo real.

Asegúrate de tener todas las dependencias necesarias instaladas y de que el entorno esté configurado correctamente para ejecutar la aplicación de Flutter.