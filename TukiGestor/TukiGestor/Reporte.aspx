<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Reporte.aspx.cs" Inherits="TukiGestor.WebForm1" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <%: Styles.Render("~/Content/reportes") %>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="reporte-container">

        <div class="tabs-container">
            <h2 class="mb-4" style="color: #333; font-weight: bold;">
                <i class="bi bi-graph-up"></i>
                Reporte 
            </h2>

            <div>
                <ul class="nav nav-tabs" role="tablist">
                    <li class="nav-item">
                        <button class="nav-link active" id="mesas-tab" data-bs-toggle="tab" data-bs-target="#mesas" type="button" role="tab"><i class="bi bi-fork-knife"></i>Mesas</button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link" id="mozos-tab" data-bs-toggle="tab" data-bs-target="#meseros" type="button" role="tab"><i class="bi bi-person-circle"></i>Meseros</button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link" id="productos-tab" data-bs-toggle="tab" data-bs-target="#productos" type="button" role="tab"><i class="bi bi-cup-straw"></i>Productos</button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link" id="ventas-tab" data-bs-toggle="tab" data-bs-target="#ventas" type="button" role="tab"><i class="bi bi-receipt"></i>Ventas</button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link" id="balance-tab" data-bs-toggle="tab" data-bs-target="#balance" type="button" role="tab"><i class="bi bi-book"></i>Balance</button>
                    </li>
                </ul>
            </div>

            <div class="options-container">
                <i class="bi bi-calendar-date calendario"></i>
                <div class="separador"></div>              

                  <!-- TURNO -->
                <div class="dropdown">
                <asp:DropDownList ID="ddlTurno" CssClass="btn btn-secondary dropdown-toggle boton-turno" runat="server">
                    <asp:ListItem Text="Todos" Value="Todos" CssClass="dropdown-item items-turno"></asp:ListItem>
                    <asp:ListItem Text="Almuerzo" CssClass="dropdown-item items-turno" Value="Almuerzo"></asp:ListItem>
                    <asp:ListItem Text="Cena" CssClass="dropdown-item items-turno" Value="Cena"></asp:ListItem>
                </asp:DropDownList>
                </div>

                <!-- RANGO -->
                <asp:DropDownList ID="ddlRango"  CssClass="btn btn-secondary dropdown-toggle boton-rango"
                    runat="server" ClientIDMode="Static">
                    <asp:ListItem Text="Hoy" Value="Hoy"  />
                    <asp:ListItem Text="Esta semana" Value="Semana"  />
                    <asp:ListItem Text="Este Mes" Value="Mes"  />
                    <asp:ListItem Text="Este Año" Value="Año"  />
                    <asp:ListItem Text="Fechas personalizadas" Value="Personalizado" />
                </asp:DropDownList>


                <div class="separador"></div>

                <div class="date-selector-container">

                    <!-- selector personalizado -->
                    <div class="selector-rango">
                        <asp:TextBox ID="txtFechaDesde" runat="server"
                            CssClass="custom-datepicker"
                            TextMode="Date"
                            ClientIDMode="Static" />

                        <span class="fecha-hasta" id="fecha-hasta-label">hasta</span>

                        <asp:TextBox ID="txtFechaHasta" runat="server"
                            CssClass="custom-datepicker"
                            TextMode="Date"
                            ClientIDMode="Static" />
                    </div>
                </div>

            </div>




            <!--   Pestaña Mesas -->           

            <div class="tab-pane fade active show pestaña-mesas" id="mesas" role="tabpanel">
                <div class="options-container-pestañas">

                    <!-- 1. Ranking (siempre es uno solo, pero mantenemos la UI) -->
                    <div class="dropdown">
                        <asp:DropDownList ID="ddlRankingMesas"
                            runat="server"
                            CssClass="btn btn-secondary dropdown-toggle boton-ranking"
                            ClientIDMode="Static">
                            <asp:ListItem Text="Ranking de mesas" Value="Ranking" />
                        </asp:DropDownList>
                    </div>

                    <!-- Ubicación-->
                    <div class="dropdown">
                        <asp:DropDownList ID="ddlUbicacion"
                            runat="server"
                            CssClass="btn btn-secondary dropdown-toggle boton-ranking"
                            ClientIDMode="Static">
                            <asp:ListItem Text="Todas" Value="Todos" />
                            <asp:ListItem Text="Salón" Value="Salon" />
                            <asp:ListItem Text="Patio" Value="Patio" />
                        </asp:DropDownList>
                    </div>

                    <!-- Con más / Con menos -->
                    <div class="dropdown">
                        <asp:DropDownList ID="ddlCriterioOrdenMesas"
                            runat="server"
                            CssClass="btn btn-secondary dropdown-toggle boton-ranking"
                            ClientIDMode="Static">
                            <asp:ListItem Text="Con más" Value="Mas" />
                            <asp:ListItem Text="Con menos" Value="Menos" />
                        </asp:DropDownList>
                    </div>

                    <!--  Facturación / Ocupación -->
                    <div class="dropdown">
                        <asp:DropDownList ID="ddlTipoBusqueda"
                            runat="server"
                            CssClass="btn btn-secondary dropdown-toggle boton-ranking"
                            ClientIDMode="Static">
                            <asp:ListItem Text="Facturación" Value="Facturacion" />
                            <asp:ListItem Text="Ocupación" Value="Ocupacion" />
                        </asp:DropDownList>
                    </div>


                    <!-- buscar -->                                       
                        <asp:Button ID="btnBuscarMesas"
                            runat="server"
                            Text="🔍 Buscar"
                            CssClass="btn btn-secondary boton-buscar"
                            OnClick="btnBuscarMesas_Click" />                   
                    
                </div>
            </div>

            <!--  > Pestaña Meseros <!-->
            <div class="tab-pane fade pestaña-meseros" id="meseros" role="tabpanel">
                <div class="options-container-pestañas">
                    <div class="dropdown">
                        <button class="btn btn-secondary dropdown-toggle boton-ranking" type="button" data-bs-toggle="dropdown" aria-expanded="false">Ranking de meseros</button>
                        <ul class="dropdown-menu">
                            <li>
                                <button class="dropdown-item items-mesas" type="button">Ranking de meseros</button>
                            </li>
                        </ul>
                    </div>
                    <div class="dropdown">
                        <button class="btn btn-secondary dropdown-toggle boton-ranking" type="button" data-bs-toggle="dropdown" aria-expanded="false">Con más</button>
                        <ul class="dropdown-menu">
                            <li>
                                <button class="dropdown-item items-mesas" type="button">Con más</button>
                            </li>
                            <li>
                                <button class="dropdown-item items-mesas" type="button">Con menos</button>
                            </li>
                        </ul>
                    </div>
                    <div class="dropdown">
                        <button class="btn btn-secondary dropdown-toggle boton-ranking" type="button" data-bs-toggle="dropdown" aria-expanded="false">Facturación</button>
                        <ul class="dropdown-menu">
                            <li>
                                <button class="dropdown-item items-mesas" type="button">Facturación</button>
                            </li>
                            <li>
                                <button class="dropdown-item items-mesas" type="button">Mesas atendidas</button>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>

            <!--  > Pestaña productos <!-->
            <div class="tab-pane fade pestaña-productos" id="productos" role="tabpanel">
                <div class="options-container-pestañas">
                    <div class="dropdown">
                        <button class="btn btn-secondary dropdown-toggle boton-ranking" type="button" data-bs-toggle="dropdown" aria-expanded="false">Ranking</button>
                        <ul class="dropdown-menu">
                            <li>
                                <button class="dropdown-item items-mesas" type="button">Ranking</button>
                            </li>
                        </ul>
                    </div>
                    <div class="dropdown">
                        <button class="btn btn-secondary dropdown-toggle boton-ranking" type="button" data-bs-toggle="dropdown" aria-expanded="false">10 Productos</button>
                        <ul class="dropdown-menu">
                            <li>
                                <button class="dropdown-item items-productos" type="button">10 Productos</button>
                            </li>
                            <li>
                                <button class="dropdown-item items-productos" type="button">20 Productos</button>
                            </li>
                            <li>
                                <button class="dropdown-item items-productos" type="button">30 Productos</button>
                            </li>
                            <li>
                                <button class="dropdown-item items-productos" type="button">40 Productos</button>
                            </li>
                            <li>
                                <button class="dropdown-item items-productos" type="button">50 Productos</button>
                            </li>
                        </ul>
                    </div>
                    <div class="dropdown">
                        <button class="btn btn-secondary dropdown-toggle boton-ranking" type="button" data-bs-toggle="dropdown" aria-expanded="false">Con más</button>
                        <ul class="dropdown-menu">
                            <li>
                                <button class="dropdown-item items-productos" type="button">Con más</button>
                            </li>
                            <li>
                                <button class="dropdown-item items-productos" type="button">Con menos</button>
                            </li>
                        </ul>
                    </div>
                    <div class="dropdown">
                        <button class="btn btn-secondary dropdown-toggle boton-ranking" type="button" data-bs-toggle="dropdown" aria-expanded="false">Facturación</button>
                        <ul class="dropdown-menu">
                            <li>
                                <button class="dropdown-item items-mesas" type="button">Facturación</button>
                            </li>
                            <li>
                                <button class="dropdown-item items-mesas" type="button">Ventas</button>
                            </li>
                            <li>
                                <button class="dropdown-item items-mesas" type="button">Margen</button>
                            </li>
                        </ul>
                    </div>
                    <div class="dropdown">
                        <button class="btn btn-secondary dropdown-toggle boton-ranking" type="button" data-bs-toggle="dropdown" aria-expanded="false">Categoría</button>
                        <ul class="dropdown-menu">
                            <li>
                                <button class="dropdown-item items-mesas" type="button">Categoría</button>
                            </li>
                            <li>
                                <button class="dropdown-item items-mesas" type="button">Bebidas</button>
                            </li>
                            <li>
                                <button class="dropdown-item items-mesas" type="button">Platos Principales</button>
                            </li>
                            <li>
                                <button class="dropdown-item items-mesas" type="button">Postres</button>
                            </li>
                            <li>
                                <button class="dropdown-item items-mesas" type="button">Adicionales</button>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="tab-pane fade pestaña-ventas" id="ventas" role="tabpanel">
                <div class="options-container-pestañas">
                    <div class="dropdown">
                        <button class="btn btn-secondary dropdown-toggle boton-ranking" type="button" data-bs-toggle="dropdown" aria-expanded="false">Tipo de pago</button>
                        <ul class="dropdown-menu">
                            <li>
                                <button class="dropdown-item items-ventas" type="button">Efectivo</button>
                            </li>
                            <li>
                                <button class="dropdown-item items-ventas" type="button">Tarjeta de Crédito</button>
                            </li>
                            <li>
                                <button class="dropdown-item items-ventas" type="button">Transferencia</button>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <script>     
                
        const ddlRango = document.getElementById('ddlRango');
        const itemsTurno = document.querySelectorAll(".items-turno");
        const botonTurno = document.querySelector('.boton-turno');
        const botonRango = document.querySelector('.boton-rango');
        const selectorRango = document.querySelector(".selector-rango");  

        ddlRango.addEventListener("change", function () {

            const rangoElegido = ddlRango.value;

            switch (rangoElegido) {
                

                case "Personalizado":
                    
                    selectorRango.style.display = "flex";
                    break;

                default:                   
                    selectorRango.style.display = "none";
                    break;
            }
        })

  


    </script>


</asp:Content>


