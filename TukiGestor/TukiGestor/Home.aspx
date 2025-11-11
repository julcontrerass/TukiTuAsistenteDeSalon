<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="TukiGestor.About" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .container.body-content {
            padding: 0 !important;
            margin: 0 !important;
            margin-bottom: 0 !important;
            max-width: 100% !important;
            width: 100% !important;
            height: calc(100vh - 80px);
            flex: 1 !important;
            overflow: visible !important;
        }

        .home-container {
            position: fixed;
            left: calc(50vw + 140px);
            top: calc(50vh - 40px);
            transform: translate(-50%, -50%);
            z-index: 100;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 20px;
        }

        .sidebar.collapsed ~ .main-wrapper .home-container {
            left: calc(50vw + 40px);
        }
        
        .welcome-section {
            background-color: #fff;
            border-radius: 15px;
            padding: 50px 40px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            max-width: 800px;
            width: 100%;
        }
        
        .welcome-section h2 {
            color: #666;
            font-size: 1.8em;
            margin-bottom: 15px;
            font-weight: 300;
        }
        
        .welcome-section p {
            color: #777;
            font-size: 1.2em;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        
        .btn-primary-custom {
            background-color: #E7D8C1;
            color: #333;
            padding: 12px 30px;
            border: none;
            border-radius: 25px;
            font-size: 1.1em;
            cursor: pointer;
            transition: background-color 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-primary-custom:hover {
            background-color: #d4c5ae;
            color: #000;
            text-decoration: none;
        }

        .reloj-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1000;
            background-color: #fff;
            border-radius: 10px;
            padding: 15px 25px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .reloj-hora {
            font-size: 2em;
            font-weight: 600;
            color: #333;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .reloj-fecha {
            font-size: 0.9em;
            color: #666;
            margin-top: 5px;
            text-align: center;
        }
    </style>

    <div class="reloj-container">
        <div class="reloj-hora" id="relojHora">00:00:00</div>
        <div class="reloj-fecha" id="relojFecha"></div>
    </div>

    <div class="home-container">
        <div class="welcome-section">
            <h2>Bienvenido a tu asistente de salón</h2>
            <p>Gestiona tu negocio de manera eficiente con nuestras herramientas diseñadas especialmente para salones y restaurantes</p>
            <a href="Mesas.aspx" class="btn-primary-custom">Comenzar</a>
        </div>
    </div>

    <script>
        function actualizarReloj() {
            const ahora = new Date();

            // Formatear hora
            const horas = String(ahora.getHours()).padStart(2, '0');
            const minutos = String(ahora.getMinutes()).padStart(2, '0');
            const segundos = String(ahora.getSeconds()).padStart(2, '0');

            // Formatear fecha
            const dias = ['Domingo', 'Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado'];
            const meses = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];

            const diaSemana = dias[ahora.getDay()];
            const dia = ahora.getDate();
            const mes = meses[ahora.getMonth()];
            const año = ahora.getFullYear();

            // Actualizar elementos
            document.getElementById('relojHora').textContent = `${horas}:${minutos}:${segundos}`;
            document.getElementById('relojFecha').textContent = `${diaSemana}, ${dia} de ${mes} de ${año}`;
        }

        // Actualizar reloj cada segundo
        actualizarReloj();
        setInterval(actualizarReloj, 1000);
    </script>
</asp:Content>