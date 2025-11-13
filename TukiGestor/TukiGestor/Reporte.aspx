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
            <asp:UpdatePanel ID="UpdatePanelMensajes"  runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <asp:Panel ID="pnlMensaje" ClientIDMode="Static" runat="server" Style="display:none;" CssClass="alert-custom">
                        <asp:Label ID="lblMensaje" runat="server"></asp:Label>
                    </asp:Panel>
                </ContentTemplate>
            </asp:UpdatePanel>
            <div>
                <ul class="nav nav-tabs" role="tablist">

                    <li class="nav-item">
                        <asp:LinkButton ID="btnTabMesas" runat="server" CssClass="nav-link active"
                            OnClick="btnTabMesas_Click">
            <i class="bi bi-fork-knife"></i> Mesas
                        </asp:LinkButton>
                    </li>

                    <li class="nav-item">
                        <asp:LinkButton ID="btnTabMeseros" runat="server" CssClass="nav-link"
                            OnClick="btnTabMeseros_Click">
            <i class="bi bi-person-circle"></i> Meseros
                        </asp:LinkButton>
                    </li>

                    <li class="nav-item">
                        <asp:LinkButton ID="btnTabProductos" runat="server" CssClass="nav-link"
                            OnClick="btnTabProductos_Click">
            <i class="bi bi-cup-straw"></i> Productos
                        </asp:LinkButton>
                    </li>

                    <li class="nav-item">
                        <asp:LinkButton ID="btnTabVentas" runat="server" CssClass="nav-link"
                            OnClick="btnTabVentas_Click">
            <i class="bi bi-receipt"></i> Ventas
                        </asp:LinkButton>
                    </li>

                    <li class="nav-item">
                        <asp:LinkButton ID="btnTabBalance" runat="server" CssClass="nav-link"
                            OnClick="btnTabBalance_Click">
            <i class="bi bi-book"></i> Balance
                        </asp:LinkButton>
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
                <asp:DropDownList ID="ddlRango" CssClass="btn btn-secondary dropdown-toggle boton-rango"
                    runat="server" ClientIDMode="Static">
                    <asp:ListItem Text="Hoy" Value="Hoy" />
                    <asp:ListItem Text="Esta semana" Value="Semana" />
                    <asp:ListItem Text="Este Mes" Value="Mes" />
                    <asp:ListItem Text="Este Año" Value="Año" />
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


            <asp:Panel ID="pnlMesas" runat="server" CssClass="tab-pane fade active show">

                <!--   Pestaña Mesas -->

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
                            <asp:DropDownList ID="ddlUbicacionMesas"
                                runat="server"
                                CssClass="btn btn-secondary dropdown-toggle boton-ranking"
                                ClientIDMode="Static">
                                <asp:ListItem Text="Mesas" Value="Todos" Disabled="True" ></asp:ListItem>

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

            </asp:Panel>

            <asp:Panel ID="pnlMeseros" runat="server" CssClass="tab-pane fade">

                <!--  > Pestaña Meseros <!-->
                    <div class="options-container-pestañas">
                        <div class="dropdown">
                            <asp:DropDownList ID="ddlRankingMeseros"
                                runat="server"
                                CssClass="btn btn-secondary dropdown-toggle boton-ranking"
                                ClientIDMode="Static">
                                <asp:ListItem Text="Ranking de meseros" Value="Ranking" />
                            </asp:DropDownList>
                        </div>

                        <!-- Ubicación-->
                        <div class="dropdown">
                            <asp:DropDownList ID="ddlUbicacionMeseros"
                                runat="server"
                                CssClass="btn btn-secondary dropdown-toggle boton-ranking"
                                ClientIDMode="Static">
                                <asp:ListItem Text="Mesas" Value="Todos" Disabled="True" Selected="True"></asp:ListItem>

                                <asp:ListItem Text="Todas" Value="Todos" />
                                <asp:ListItem Text="Salón" Value="Salon" />
                                <asp:ListItem Text="Patio" Value="Patio" />
                            </asp:DropDownList>
                        </div>

                        <div class="dropdown">
                            <asp:DropDownList ID="ddlCriterioOrdenMeseros"
                                runat="server"
                                CssClass="btn btn-secondary dropdown-toggle boton-ranking"
                                ClientIDMode="Static">
                                <asp:ListItem Text="Con más" Value="Mas" />
                                <asp:ListItem Text="Con menos" Value="Menos" />
                            </asp:DropDownList>
                        </div>

                        <div class="dropdown">
                            <asp:DropDownList ID="ddlCriterioBusquedaMeseros"
                                runat="server"
                                CssClass="btn btn-secondary dropdown-toggle boton-ranking"
                                ClientIDMode="Static">
                                <asp:ListItem Text="Facturación" Value="Facturacion" />
                                <asp:ListItem Text="Mesas atendidas" Value="Mesas atendidas" />
                            </asp:DropDownList>
                        </div>
                        <asp:Button ID="btnMeserosBuscar"
                            runat="server"
                            Text="🔍 Buscar"
                            CssClass="btn btn-secondary boton-buscar"
                            OnClick="btnMeserosBuscar_Click" />


                    </div>
                


            </asp:Panel>

            <asp:Panel ID="pnlProductos" runat="server" CssClass="tab-pane fade ">

                <div class="options-container-pestañas">

                    <!-- 1. Ranking -->
                    <div class="dropdown">
                        <asp:DropDownList ID="ddlRankingProductos"
                            runat="server"
                            CssClass="btn btn-secondary dropdown-toggle boton-ranking"
                            ClientIDMode="Static">
                            <asp:ListItem Text="Ranking productos" Value="Ranking" />
                        </asp:DropDownList>
                    </div>

                     <div class="dropdown">
     <asp:DropDownList ID="ddlUbicacionProductos"
         runat="server"
         CssClass="btn btn-secondary dropdown-toggle boton-ranking"
         ClientIDMode="Static">
         <asp:ListItem Text="Mesas" Value="Todos" Disabled="True" Selected="True"></asp:ListItem>

         <asp:ListItem Text="Todas" Value="Todos" />
         <asp:ListItem Text="Salón" Value="Salon" />
         <asp:ListItem Text="Patio" Value="Patio" />
     </asp:DropDownList>
 </div>

                    <div class="dropdown">
                        <asp:DropDownList ID="ddlCantidadProductos"
                            runat="server"
                            CssClass="btn btn-secondary dropdown-toggle boton-ranking"
                            ClientIDMode="Static">
                            <asp:ListItem Text="10 Productos" Value="10" />
                            <asp:ListItem Text="20 Productos" Value="20" />
                            <asp:ListItem Text="30 Productos" Value="30" />
                            <asp:ListItem Text="40 Productos" Value="40" />
                            <asp:ListItem Text="50 Productos" Value="50" />
                        </asp:DropDownList>
                    </div>

                    <div class="dropdown">
                        <asp:DropDownList ID="ddlCriterioOrdenProductos"
                            runat="server"
                            CssClass="btn btn-secondary dropdown-toggle boton-ranking"
                            ClientIDMode="Static">
                            <asp:ListItem Text="Con más" Value="Mas" />
                            <asp:ListItem Text="Con menos" Value="Menos" />
                        </asp:DropDownList>
                    </div>

                    <div class="dropdown">
                        <asp:DropDownList ID="ddlCriterioBusquedaProductos"
                            runat="server"
                            CssClass="btn btn-secondary dropdown-toggle boton-ranking"
                            ClientIDMode="Static">
                            <asp:ListItem Text="Facturación" Value="Facturacion" />
                            <asp:ListItem Text="Ventas" Value="Ventas" />
                        </asp:DropDownList>
                    </div>

                    <div class="dropdown">
                        <asp:DropDownList ID="ddlCategoriaProductos"
                            runat="server"
                            CssClass="btn btn-secondary dropdown-toggle boton-ranking"
                            ClientIDMode="Static">
                            <asp:ListItem Text="Categoria" Value="Todos" Disabled="True" />
                             <asp:ListItem Text="Todas" Value="Todos"/>
                            <asp:ListItem Text="Platos Principales" Value="Comida" />
                            <asp:ListItem Text="Bebidas" Value="Bebidas" />
                            <asp:ListItem Text="Postres" Value="Postres" />
                            
                        </asp:DropDownList>
                    </div>

                    <asp:Button
                        ID="btnBuscarProductos"
                        runat="server"
                        Text="🔍 Buscar"
                        CssClass="btn btn-secondary boton-buscar"
                        onclick="btnBuscarProductos_Click" />
                </div>

            </asp:Panel>

                        <asp:Panel ID="pnlVentas" runat="server" CssClass="tab-pane fade">

                            
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

                        </asp:Panel>

                        <asp:Panel ID="pnlBalance" runat="server" CssClass="tab-pane fade"></asp:Panel>


            <asp:Panel ID="pnlResultadoMesas" runat="server" ClientIDMode="Static" Visible="false" UpdateMode="Conditional">

                <asp:GridView ID="gvMesas" runat="server"
                    AutoGenerateColumns="False"
                    CssClass="table table-striped table-hover text-center shadow-lg"
                    HeaderStyle-CssClass="table-dark"
                    EmptyDataText="No hay resultados para mostrar."
                    GridLines="None">
                    <Columns>
                        <asp:BoundField
                            DataField="NumeroMesa"
                            HeaderText="Mesa"
                            SortExpression="NumeroMesa" />

                        <asp:BoundField
                            DataField="Ubicacion"
                            HeaderText="Ubicación"
                            SortExpression="Ubicacion" />

                        <asp:BoundField
                            DataField="Facturacion"
                            HeaderText="Facturación"
                            DataFormatString="{0:C}"
                            HtmlEncode="false"
                            SortExpression="Facturacion" />

                        <asp:BoundField
                            DataField="Ocupacion"
                            HeaderText="Ocupación"
                            SortExpression="Ocupacion" />

                    </Columns>
                </asp:GridView>
              </asp:Panel>

            <asp:Panel ID="PnlResultadoMeseros" runat="server" ClientIDMode="Static" Visible="false" UpdateMode="Conditional">
                <asp:GridView ID="gvMeseros" runat="server"
                    AutoGenerateColumns="False"
                    CssClass="table table-striped table-hover text-center shadow-lg"
                    HeaderStyle-CssClass="table-dark"
                    EmptyDataText="No hay resultados para mostrar."
                    GridLines="None">
                    <Columns>
                        <asp:BoundField
                            DataField="NombreApellido"
                            HeaderText="Mesero"
                            SortExpression="NumeroMesa" />

                        <asp:BoundField
                            DataField="Facturacion"
                            HeaderText="Facturación"
                            DataFormatString="{0:C}"
                            HtmlEncode="false"
                            SortExpression="Facturacion" />

                        <asp:BoundField
                            DataField="MesasAtendidas"
                            HeaderText="Mesas Atendidas"
                            SortExpression="MesasAtendidas" />

                    </Columns>
                </asp:GridView>
            </asp:Panel>


            <asp:Panel ID="pnlResultadosProductos" runat="server" ClientIDMode="Static" Visible="false" UpdateMode="Conditional">
                <asp:GridView ID="gvProductos" runat="server"
                    AutoGenerateColumns="False"
                    CssClass="table table-striped table-hover text-center shadow-lg"
                    HeaderStyle-CssClass="table-dark"
                    EmptyDataText="No hay resultados para mostrar."
                    GridLines="None">
                    <Columns>
                        <asp:BoundField
                            DataField="NombreProducto"
                            HeaderText="Producto"
                            SortExpression="NombreProducto" />
                        <asp:BoundField
                            DataField="Categoria"
                            HeaderText="Categoría"
                            SortExpression="Categoria" />

                        <asp:BoundField
                            DataField="Facturacion"
                            HeaderText="Facturación"
                            DataFormatString="{0:C}"
                            HtmlEncode="false"
                            SortExpression="Facturacion" />

                        <asp:BoundField
                            DataField="CantidadVendida"
                            HeaderText="Cantidad vendida"
                            SortExpression="CantidadVendida" />

                    </Columns>
                </asp:GridView>
            </asp:Panel>


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


        document.querySelectorAll('[data-bs-toggle="tab"]').forEach(tab => {
            tab.addEventListener("shown.bs.tab", ()=> {
                // Oculta todos los resultados de reportes
                document.getElementById("pnlResultadoMesas").style.display = "none";                
                //document.getElementById("panelMeseros").style.display = "none";
                //document.getElementById("panelProductos").style.display = "none";
                //document.getElementById("panelVentas").style.display = "none";
                //document.getElementById("panelBalance").style.display = "none";       

                const panel = document.getElementById("pnlMensaje");
                console.log("la concha tu madre", panel);
                if (panel) {
                    panel.style.display = "none";
                    panel.classList.remove("alert-show");
                }


            });
        });



    </script>


</asp:Content>


