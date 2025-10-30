<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Reporte.aspx.cs" Inherits="TukiGestor.WebForm1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .reporte-container {
            position: fixed;
            left: calc(50vw + 140px);
            transform: translateX(-50%);
            top: 40px;
            z-index: 100;
            min-width: 80%;
            max-width: 1400px;
            padding: 20px;
            padding-bottom: 120px;
            min-height: 80vh; 
        }

        .tabs-container {
            background: #F6EFE0;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            min-height: 80vh;
        }

        .nav-tabs {
            border-bottom: 2px solid #E7D9C2;
            margin-bottom: 10px;
        }

            .nav-tabs .nav-link {
                color: #333;
                border: none;
                padding: 12px 30px;
                font-weight: 600;
                border-radius: 8px 8px 0 0;
                transition: all 0.3s ease;
            }

                .nav-tabs .nav-link:hover {
                    background-color: #E7D9C2;
                    color: #333;
                }

                .nav-tabs .nav-link.active {
                    background-color: #E7D9C2;
                    color: #333;
                    border: none;
                }

        .dropdown-color {
            background-color: #E7D9C2;
        }



        .calendario::before {
            font-size: 2rem;
            align-self: center
        }

        .options-container {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 0.75rem;
            background-color: #E7D9C2;
        }

        .separador {
            width: 1px;
            min-height: 45px;
            height: 100%;
            background-color: #a9a7a7;
        }


        .date.date-selector-container {
            display: flex;          
        }

       

        .custom-datepicker {
            padding: 0.75rem 1rem;
            border-radius: 8px;
            border: none;
            background-color: #E7D9C2;
            color: #333;
            font-weight: 600;
            font-size: 1rem;
            transition: all 0.3s ease;
            outline: none;
            cursor: pointer;
        }


            .custom-datepicker:hover,
            .custom-datepicker:focus {
                background-color: #d9cbb0;
                color: #333;
            }

            .custom-datepicker::-webkit-calendar-picker-indicator {
                filter: invert(0.4);
                cursor: pointer;
            }

            .custom-datepicker::-moz-focus-inner {
                border: 0;
            }

        .fecha-hasta {
            font-size: 1rem;
            
        }

        .selector-rango {
            display: none;
            align-items: center;
            gap: 0.75rem;
        }

        .selector-mes {
            display: none;
            align-items: center;
        }

        .selector-año {
            display: none;
            align-items: center;
            gap: 0.75rem;
        }

        .selector-año-label {
            font-weight: 600;
        }

        .boton-rango, .boton-turno {
            background-color: #646464;
            border: none;
            min-width: 100px;
        }

        .options-container-pestañas{
            display: flex;
            padding-block: 10px;
            gap: .75rem;
        }

        .boton-ranking{
            background-color: #E7D9C2;    
            color: #333;
            border: none;
        }

        .tab-pane {
  display: none;
  opacity: 0;
  transition: opacity 0.2s ease;
}

.tab-pane.active.show {
  display: block;
  opacity: 1;
}



    </style>

    <div class="reporte-container">

        <div class="tabs-container">
            <h2 class="mb-4" style="color: #333; font-weight: bold;">
                <i class="bi bi-graph-up"></i>
                Reporte 
            </h2>

            <div>
                <ul class="nav nav-tabs" role="tablist">
                    <li class="nav-item">
                        <button class="nav-link active" id="mesas-tab" data-bs-toggle="tab" data-bs-target="#mesas" type="button" role="tab">
                            <i class="bi bi-fork-knife"></i>
                            Mesas
                        </button>
                    </li>

                    <li class="nav-item">
    <button class="nav-link" id="mozos-tab" data-bs-toggle="tab" data-bs-target="#meseros" type="button" role="tab">
                    <i class="bi bi-person-circle"></i>
        Meseros
    </button>
</li>



                    <li class="nav-item">
                        <button class="nav-link" id="productos-tab" data-bs-toggle="tab" data-bs-target="#productos" type="button" role="tab">
                            <i class="bi bi-cup-straw"></i> Productos
                        </button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link" id="ventas-tab" data-bs-toggle="tab" data-bs-target="#ventas" type="button" role="tab">
                            <i class="bi bi-receipt"></i> Ventas
                        </button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link" id="balance-tab" data-bs-toggle="tab" data-bs-target="#balance" type="button" role="tab">
                            <i class="bi bi-book"></i> Balance
                        </button>
                    </li>
                </ul>
            </div>

            <div class="options-container">
                <i class="bi bi-calendar-date calendario"></i>

                <div class="separador"></div>
                <div class="dropdown">
                    <button class="btn btn-secondary dropdown-toggle boton-turno" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                        Turno
                    </button>
                    <ul class="dropdown-menu">
                        <li>
                            <button class="dropdown-item items-turno" type="button">Almuerzo</button></li>
                        <li>
                            <button class="dropdown-item items-turno" type="button">Cena</button></li>
                    </ul>
                </div>

                <div class="dropdown">
                    <button class="btn btn-secondary dropdown-toggle boton-rango" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                        Rango
                    </button>
                    <ul class="dropdown-menu">
                        <li>
                            <button class="dropdown-item items-rango" type="button">Diario</button></li>
                        <li>
                            <button class="dropdown-item items-rango" type="button">Semanal</button></li>
                        <li>
                            <button class="dropdown-item items-rango" type="button">Mensual</button></li>
                        <li>
    <button class="dropdown-item items-rango" type="button">Anual</button></li>
                        <li>
                            <button class="dropdown-item items-rango" type="button">Fechas personalizadas</button></li>
                    </ul>
                </div>
                <div class="separador"></div>
               

                    <div class="date-selector-container">
                        <div class="selector-rango">
                            <input class="custom-datepicker" type="date" id="fecha-desde" lang="es-ES">
                            <span class="fecha-hasta" id="fecha-hasta-label">hasta</span>
                            <input class="custom-datepicker" type="date" id="fecha-hasta" lang="es-ES">
                        </div>

                        <div class="selector-mes">
                            <input class="custom-datepicker" type="month" id="fecha-mes">
                        </div>

                        <div class="selector-año">
                            <label for="fecha-anio" class="selector-año-label">Año</label>
                            <input class="custom-datepicker" type="number" id="fecha-anio" min="2000" max="2030" placeholder="AAAA">
                        </div>
                    </div>            

            </div>

            <!--  > Pestaña Mesas <!-->

            <div class="tab-pane fade active show pestaña-mesas" id="mesas" role="tabpanel">

                <div class="options-container-pestañas">
                    <div class="dropdown">
                        <button class="btn btn-secondary dropdown-toggle boton-ranking" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                            Ranking de mesas
                        </button>
                        <ul class="dropdown-menu">
                            <li>
                                <button class="dropdown-item items-mesas" type="button">Ranking de mesas</button></li>
                            
                        </ul>
                    </div>

                    <div class="dropdown">
    <button class="btn btn-secondary dropdown-toggle boton-ranking" type="button" data-bs-toggle="dropdown" aria-expanded="false">
        Con más
    </button>
    <ul class="dropdown-menu">
        <li>
            <button class="dropdown-item items-mesas" type="button">Con más</button></li>
        <li>
            <button class="dropdown-item items-mesas" type="button">Con menos</button></li>
    </ul>
</div>

                    <div class="dropdown">
    <button class="btn btn-secondary dropdown-toggle boton-ranking" type="button" data-bs-toggle="dropdown" aria-expanded="false">
        Facturación
    </button>
    <ul class="dropdown-menu">
        <li>
            <button class="dropdown-item items-mesas" type="button">Facturación</button></li>
        <li>
            <button class="dropdown-item items-mesas" type="button">Ocupación</button></li>
    </ul>
</div>
                </div>

            </div>

            <!--  > Pestaña Meseros <!-->
            <div class="tab-pane fade pestaña-meseros" id="meseros" role="tabpanel">

                <div class="options-container-pestañas">
                    <div class="dropdown">
                        <button class="btn btn-secondary dropdown-toggle boton-ranking" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                            Ranking de meseros
                        </button>
                        <ul class="dropdown-menu">
                            <li>
                                <button class="dropdown-item items-mesas" type="button">Ranking de meseros</button></li>
                        </ul>
                    </div>

                    <div class="dropdown">
                        <button class="btn btn-secondary dropdown-toggle boton-ranking" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                            Con más
                        </button>
                        <ul class="dropdown-menu">
                            <li>
                                <button class="dropdown-item items-mesas" type="button">Con más</button></li>
                            <li>
                                <button class="dropdown-item items-mesas" type="button">Con menos</button></li>
                        </ul>
                    </div>

                    <div class="dropdown">
                        <button class="btn btn-secondary dropdown-toggle boton-ranking" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                            Facturación     
                        </button>
                        <ul class="dropdown-menu">
                            <li>
                                <button class="dropdown-item items-mesas" type="button">Facturación</button></li>
                            <li>
                                <button class="dropdown-item items-mesas" type="button">Mesas atendidas</button></li>
                        </ul>
                    </div>

                </div>

            </div>

            <!--  > Pestaña productos <!-->
<div class="tab-pane fade pestaña-productos" id="productos" role="tabpanel">

    <div class="options-container-pestañas">
        <div class="dropdown">
            <button class="btn btn-secondary dropdown-toggle boton-ranking" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                Ranking
            </button>
            <ul class="dropdown-menu">
                <li>
                    <button class="dropdown-item items-mesas" type="button">Ranking</button></li>
            </ul>
        </div>

          <div class="dropdown">
      <button class="btn btn-secondary dropdown-toggle boton-ranking" type="button" data-bs-toggle="dropdown" aria-expanded="false">
          10 Productos
      </button>
      <ul class="dropdown-menu">
          <li>
              <button class="dropdown-item items-productos" type="button">10 Productos</button></li>
           <li>
     <button class="dropdown-item items-productos" type="button">20 Productos</button></li>
           <li>
     <button class="dropdown-item items-productos" type="button">30 Productos</button></li>
           <li>
     <button class="dropdown-item items-productos" type="button">40 Productos</button></li>
           <li>
     <button class="dropdown-item items-productos" type="button">50 Productos</button></li>
      </ul>
  </div>


        <div class="dropdown">
            <button class="btn btn-secondary dropdown-toggle boton-ranking" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                Con más
            </button>
            <ul class="dropdown-menu">
                <li>
                    <button class="dropdown-item items-productos" type="button">Con más</button></li>
                <li>
                    <button class="dropdown-item items-productos" type="button">Con menos</button></li>
            </ul>
        </div>

        <div class="dropdown">
            <button class="btn btn-secondary dropdown-toggle boton-ranking" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                Facturación     
            </button>
            <ul class="dropdown-menu">
                <li>
                    <button class="dropdown-item items-mesas" type="button">Facturación</button></li>
                <li>
                    <button class="dropdown-item items-mesas" type="button">Ventas</button></li>
                <li>
    <button class="dropdown-item items-mesas" type="button">Margen</button></li>
            </ul>
        </div>

            <div class="dropdown">
        <button class="btn btn-secondary dropdown-toggle boton-ranking" type="button" data-bs-toggle="dropdown" aria-expanded="false">
            Categoría     
        </button>
        <ul class="dropdown-menu">
            <li>
                <button class="dropdown-item items-mesas" type="button">Categoría</button></li>
            <li>
                <button class="dropdown-item items-mesas" type="button">Bebidas</button></li>
            <li>
<button class="dropdown-item items-mesas" type="button">Platos Principales</button></li>
                        <li>
<button class="dropdown-item items-mesas" type="button">Postres</button></li>
                                    <li>
<button class="dropdown-item items-mesas" type="button">Adicionales</button></li>
        </ul>
    </div>


    </div>

</div>


        

   <div class="tab-pane fade pestaña-ventas" id="ventas" role="tabpanel">
       <div class="options-container-pestañas">
           <div class="dropdown">
               <button class="btn btn-secondary dropdown-toggle boton-ranking" type="button" data-bs-toggle="dropdown" aria-expanded="false">
Tipo de pago               </button>
               <ul class="dropdown-menu">
                   <li>
                       <button class="dropdown-item items-ventas" type="button">Efectivo</button></li>
                   <li>
                       <button class="dropdown-item items-ventas" type="button">Tarjeta de Crédito</button></li>
                   <li>
    <button class="dropdown-item items-ventas" type="button">Transferencia</button></li>
               </ul>
           </div>
       </div>
   </div>




        </div>


    </div>


    <script>     

        let turnoElegido = ""
        let rangoElegido = "";
        const itemsRango = document.querySelectorAll('.items-rango');
        const itemsTurno = document.querySelectorAll(".items-turno");
        const botonTurno = document.querySelector('.boton-turno');
        const botonRango = document.querySelector('.boton-rango');
        const selectorRango = document.querySelector(".selector-rango");
        const selectorMes = document.querySelector(".selector-mes");
        const selectorAño = document.querySelector(".selector-año");


        itemsRango.forEach(item => {
            item.addEventListener('click', function () {
                botonRango.textContent = this.textContent;
                rangoElegido = this.textContent; 

                switch (rangoElegido) {
                    case "Mensual":
                        selectorMes.style.display = "flex"
                        selectorAño.style.display = "none";
                        selectorRango.style.display = "none";
                        break;

                    case "Anual":
                        selectorMes.style.display = "none"
                        selectorAño.style.display = "flex";                        
                        selectorRango.style.display = "none";
                        break;

                    case "Fechas personalizadas":
                        selectorMes.style.display = "none"
                        selectorAño.style.display = "none";
                        selectorRango.style.display = "flex";                       
                        break;

                    default:
                        selectorMes.style.display = "none"
                        selectorAño.style.display = "none";
                        selectorRango.style.display = "none";
                        break;
                }
            })
        });

        itemsTurno.forEach(item => {
            item.addEventListener('click', function () {
                botonTurno.textContent = this.textContent;
                turnoElegido = this.textContent;
            })
        }); 
  


    </script>


</asp:Content>


