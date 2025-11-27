<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="TukiGestor.About" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <%: Styles.Render("~/Content/home") %>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <!-- PANEL SUPERIOR IZQUIERDA (ÓRDENES ABIERTAS) -->
    <asp:Panel ID="pnlOrdenesAbiertas" runat="server" Visible="false">
        <div class="panel-superior-izquierda">
            <div class="card-home ordenes-card">
                <h3 class="card-title">🧾 Órdenes Abiertas</h3>

                <asp:Repeater ID="RepeaterOrdenes" runat="server">
                    <ItemTemplate>
                        <div class="orden-item">
                            <div class="orden-header">
                                <div>
                                    <span class="orden-id">Orden #<%# Eval("PedidoId") %></span>
                                    <div class="orden-ubicacion">
                                        <span><%# Eval("Ubicacion") %></span>
                                        <%# (bool)Eval("MostrarMesero") ? "<span class='orden-mesero'> - " + Eval("Mesero") + "</span>" : "" %>
                                    </div>
                                </div>
                                <span class="orden-fecha">
                                    <%# ((DateTime)Eval("FechaPedido")).ToString("HH:mm") %>
                                </span>
                            </div>

                            <div class="orden-body">
                                <%# Eval("DescripcionResumen") %>
                            </div>

                            <div class="orden-footer">
                                Total: $<%# ((decimal)Eval("Total")).ToString("N0") %>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </asp:Panel>

    <!-- CONTENEDOR FIJO SUPERIOR DERECHA (RELOJ + ALERTAS) -->
    <div class="panel-superior-derecha">

        <!-- RELOJ -->
        <div class="reloj-container">
            <div class="reloj-hora" id="relojHora">00:00:00</div>
            <div class="reloj-fecha" id="relojFecha"></div>
        </div>

        <!-- ALERTAS DE STOCK -->
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

    </div>

    <!-- CONTENIDO CENTRAL -->
    <div class="home-container">
        <div class="welcome-section">
            <h2>Bienvenido a tu asistente de salón</h2>
            <p>Gestiona tu negocio de manera eficiente con nuestras herramientas diseñadas especialmente para salones y restaurantes</p>
            <a href="Mesas.aspx" class="btn-primary-custom">Comenzar</a>
        </div>
    </div>

    <!-- SCRIPT DEL RELOJ -->
    <script>
        function actualizarReloj() {
            const ahora = new Date();

            const horas = String(ahora.getHours()).padStart(2, '0');
            const minutos = String(ahora.getMinutes()).padStart(2, '0');
            const segundos = String(ahora.getSeconds()).padStart(2, '0');

            const dias = ['Domingo', 'Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado'];
            const meses = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];

            const diaSemana = dias[ahora.getDay()];
            const dia = ahora.getDate();
            const mes = meses[ahora.getMonth()];
            const año = ahora.getFullYear();

            document.getElementById('relojHora').textContent = `${horas}:${minutos}:${segundos}`;
            document.getElementById('relojFecha').textContent = `${diaSemana}, ${dia} de ${mes} de ${año}`;
        }

        actualizarReloj();
        setInterval(actualizarReloj, 1000);
    </script>

</asp:Content>