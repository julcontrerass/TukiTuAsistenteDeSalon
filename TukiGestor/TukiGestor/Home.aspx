<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="TukiGestor.About" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <%: Styles.Render("~/Content/home") %>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="reloj-container">
        <div class="reloj-hora" id="relojHora">00:00:00</div>
        <div class="reloj-fecha" id="relojFecha"></div>
    </div>
    <asp:Panel ID="pnlStockBajo" runat="server" Visible="false">
        <div class="card-home alertas-card">
            <h3 class="card-title">⚠ Stock Bajo</h3>
            <asp:Repeater ID="RepeaterAlertas" runat="server">
                <ItemTemplate>
                    <div class="alerta-item">
                        <div class="alerta-nombre"><%# Eval("Nombre") %></div>
                        <div class="alerta-stock">
                            Stock: <span class="alerta-numero"><%# Eval("Stock") %></span>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </asp:Panel>
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
