using dominio;
using Service;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TukiGestor
{
    public partial class Stock : System.Web.UI.Page
    {
        

        /* private void CargarProductos()
         {
             ProductoService productoService = new ProductoService();
             List<Producto> listaProductos = productoService.Listar();
             RepeaterProductos.DataSource = listaProductos;
             RepeaterProductos.DataBind();
         }
        */
        

       
        


        private void CargarCategorias()
        {

            Usuario usuarioLoggeado = (Usuario)Session["usuarioLoggeado"];            

            CategoriaService categoriaService = new CategoriaService();
            List<Categoria> categorias = categoriaService.Listar();
            ddlCategorias.DataSource = categorias;
            ddlCategorias.DataTextField = "Nombre";
            ddlCategorias.DataValueField = "CategoriaId";

            if (usuarioLoggeado.Rol == "mesero")
            {
                RepeaterCategorias.Columns[1].Visible = false;
            }


            ddlCategorias.DataBind();
            ddlCategorias.Items.Insert(0, new ListItem("-- Seleccione categoría --", "0"));
        }

        private void CargarCategoriasEditar()
        {
            CategoriaService categoriaService = new CategoriaService();
            List<Categoria> categorias = categoriaService.Listar();
            ddlCategoriasEditar.DataSource = categorias;
            ddlCategoriasEditar.DataTextField = "Nombre";
            ddlCategoriasEditar.DataValueField = "CategoriaId";
            ddlCategoriasEditar.DataBind();
        }

        private void CargarListadoCategorias()
        {
            try
            {
                CategoriaService categoriaService = new CategoriaService();
                List<Categoria> categorias = categoriaService.Listar();
                RepeaterCategorias.DataSource = categorias;
                RepeaterCategorias.DataBind();
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al cargar categorías: " + ex.Message, "error");
            }
        }

        // ========== mensajes ==========
        private void MostrarMensaje(string mensaje, string tipo)
        {
            pnlMensaje.Visible = true;
            lblMensaje.Text = mensaje;
            pnlMensaje.CssClass = "alert-custom";

            if (tipo == "success")
                pnlMensaje.CssClass += " alert-success";
            else if (tipo == "error")
                pnlMensaje.CssClass += " alert-danger";
            else if (tipo == "warning")
                pnlMensaje.CssClass += " alert-warning";

            UpdatePanelMensajes.Update();
        }

        private void OcultarMensaje()
        {
            pnlMensaje.Visible = false;
        }

        
        protected void btnTabListado_Click(object sender, EventArgs e)
        {
            MostrarTab("listado");
            OcultarMensaje();
        }

        protected void btnTabNuevo_Click(object sender, EventArgs e)
        {
            MostrarTab("nuevo");
            OcultarMensaje();
        }

        protected void btnTabCategorias_Click(object sender, EventArgs e)
        {
            MostrarTab("categorias");
            OcultarMensaje();
        }

        protected void btnTabCategoriaNueva_Click(object sender, EventArgs e)
        {
            MostrarTab("categoriaNueva");
            OcultarMensaje();
        }

        


        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
                string nombre = txtNombre.Text.Trim();
                string strCantidad = txtCantidad.Text.Trim();
                string strPrecio = txtPrecio.Text.Trim();
                int categoriaId = int.Parse(ddlCategorias.SelectedValue);

                // VALIDACIONES
                if (string.IsNullOrEmpty(nombre))
                {
                    MostrarMensaje("Por favor ingrese un nombre para el producto.", "warning");
                    return;
                }
                if (categoriaId == 0)
                {
                    MostrarMensaje("Por favor seleccione una categoría.", "warning");
                    return;
                }
                if (!int.TryParse(strCantidad, out int cantidad))
                {
                    MostrarMensaje("Ingrese una cantidad válida (número entero).", "warning");
                    return;
                }
                if (cantidad < 0)
                {
                    MostrarMensaje("La cantidad no puede ser negativa.", "warning");
                    return;
                }
                if (!decimal.TryParse(strPrecio, out decimal precio))
                {
                    MostrarMensaje("Ingrese un precio válido (número).", "warning");
                    return;
                }
                if (precio < 0)
                {
                    MostrarMensaje("El precio no puede ser negativo.", "warning");
                    return;
                }

                // validacion de nombre duplicado
                ProductoService service = new ProductoService();
                if (service.ExisteNombre(nombre))
                {
                    MostrarMensaje("Ya existe un producto con ese nombre. Ingrese otro.", "danger");
                    return;
                }

                Producto nuevo = new Producto
                {
                    Nombre = nombre,
                    Stock = cantidad,
                    Precio = precio,
                    Disponible = true,
                    CategoriaId = categoriaId
                };

                service.Agregar(nuevo);

                // limpiamos los campos
                txtNombre.Text = "";
                txtCantidad.Text = "";
                txtPrecio.Text = "";
                ddlCategorias.SelectedIndex = 0;

                CargarProductos();
                MostrarMensaje("Producto agregado correctamente.", "success");
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al agregar producto: " + ex.Message, "error");
            }
        }



        protected void btnActualizar_Click(object sender, EventArgs e)
        {
            try
            {
                string nombre = txtNombreEditar.Text.Trim();
                string strCantidad = txtCantidadEditar.Text.Trim();
                string strPrecio = txtPrecioEditar.Text.Trim();
                int categoriaId = int.Parse(ddlCategoriasEditar.SelectedValue);

                // VALIDACIONES
                if (string.IsNullOrEmpty(nombre))
                {
                    MostrarMensaje("Por favor ingrese un nombre para el producto.", "warning");
                    return;
                }
                if (!int.TryParse(strCantidad, out int cantidad))
                {
                    MostrarMensaje("Ingrese una cantidad válida (número entero).", "warning");
                    return;
                }
                if (cantidad < 0)
                {
                    MostrarMensaje("La cantidad no puede ser negativa.", "warning");
                    return;
                }
                if (!decimal.TryParse(strPrecio, out decimal precio))
                {
                    MostrarMensaje("Ingrese un precio válido (número).", "warning");
                    return;
                }
                if (precio < 0)
                {
                    MostrarMensaje("El precio no puede ser negativo.", "warning");
                    return;
                }

                Producto producto = new Producto
                {
                    ProductoId = int.Parse(hfProductoId.Value),
                    Nombre = nombre,
                    Stock = cantidad,
                    Precio = precio,
                    CategoriaId = categoriaId,
                    Disponible = true
                };

                ProductoService service = new ProductoService();

                // VALIDAMOS SI YA EXISTE OTRO PRODUCTO CON ESE NOMBRE
                if (service.ExisteNombre(producto.Nombre, producto.ProductoId))
                {
                    MostrarMensaje("Ya existe un producto con ese nombre. Por favor elija otro.", "warning");
                    return;
                }

                //Si pasa la validación, se actualiza
                service.Modificar(producto);

                LimpiarFormularioEditar();
                CargarProductos();
                MostrarTab("listado");
                MostrarMensaje("Producto actualizado correctamente.", "success");
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al actualizar producto: " + ex.Message, "error");
            }
        }


        protected void btnCancelarEditar_Click(object sender, EventArgs e)
        {
            LimpiarFormularioEditar();
            MostrarTab("listado");
        }

        private void LimpiarFormularioEditar()
        {
            hfProductoId.Value = "";
            txtNombreEditar.Text = "";
            txtCantidadEditar.Text = "";
            txtPrecioEditar.Text = "";
            ddlCategoriasEditar.SelectedIndex = 0;
        }


 
        protected void btnGuardarCategoria_Click(object sender, EventArgs e)
        {
            try
            {
                Categoria nueva = new Categoria();
                nueva.Nombre = txtNombreCategoria.Text.Trim();
                nueva.Activa = true;

                if (string.IsNullOrEmpty(nueva.Nombre))
                {
                    MostrarMensaje("Por favor ingrese un nombre para la categoría", "warning");
                    return;
                }

                CategoriaService service = new CategoriaService();

                // validación de nombre repetido
                if (service.ExisteNombreCategoria(nueva.Nombre))
                {
                    MostrarMensaje("Ya existe una categoría con ese nombre. Ingrese otro.", "danger");
                    return;
                }

                service.Agregar(nueva);

                txtNombreCategoria.Text = "";
                CargarCategorias();
                CargarCategoriasEditar();
                CargarListadoCategorias();
                CargarFiltroCategoria();
                MostrarMensaje("Categoría agregada correctamente", "success");
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al agregar categoría: " + ex.Message, "error");
            }
        }

  
        protected void btnActualizarCategoria_Click(object sender, EventArgs e)
        {
            try
            {
                Categoria categoria = new Categoria();
                categoria.CategoriaId = int.Parse(hfCategoriaId.Value);
                categoria.Nombre = txtNombreCategoriaEditar.Text.Trim();
                categoria.Activa = true;
                // Validación para que el nombre no pueda estar vacío
                if (string.IsNullOrEmpty(categoria.Nombre))
                {
                    MostrarMensaje("Por favor ingrese un nombre para la categoría", "warning");
                    return;
                }
                CategoriaService service = new CategoriaService();
                // validación para evitar nombres duplicados
                if (service.ExisteNombreCategoria(categoria.Nombre, categoria.CategoriaId))
                {
                    MostrarMensaje("Ya existe una categoría con ese nombre. Por favor elija otro.", "warning");
                    return;
                }
                //  Si pasa las validaciones, actualiza la categoría
                service.Modificar(categoria);
                LimpiarFormularioEditarCategoria();
                CargarCategorias();
                CargarCategoriasEditar();
                CargarListadoCategorias();
                CargarFiltroCategoria();
                MostrarTab("categorias");
                MostrarMensaje("Categoría actualizada correctamente", "success");
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al actualizar categoría: " + ex.Message, "error");
            }
        }

        protected void btnCancelarEditarCategoria_Click(object sender, EventArgs e)
        {
            LimpiarFormularioEditarCategoria();
            MostrarTab("categorias");
        }

        private void LimpiarFormularioEditarCategoria()
        {
            hfCategoriaId.Value = "";
            txtNombreCategoriaEditar.Text = "";
        }

        
        protected void btnCancelarEliminar_Click(object sender, EventArgs e)
        {
            pnlConfirmarEliminar.Visible = false;
        }


        private void CargarProductosEliminados()
        {
            ProductoService productoService = new ProductoService();
            List<Producto> listaEliminados = productoService.ListarEliminados();
            RepeaterProductosEliminados.DataSource = listaEliminados;
            RepeaterProductosEliminados.DataBind();
        }

        protected void btnTabEliminados_Click(object sender, EventArgs e)
        {
            CargarProductosEliminados(); // cargamos los datos al mostrar la solapa
            MostrarTab("eliminados");
            OcultarMensaje();
        }

        private void MostrarTab(string tab)
        {
            // ocultamos todos los paneles
            pnlListado.CssClass = "tab-pane fade";
            pnlNuevo.CssClass = "tab-pane fade";
            pnlEditar.CssClass = "tab-pane fade";
            pnlEditar.Visible = false;
            pnlCategorias.CssClass = "tab-pane fade";
            pnlCategoriaNueva.CssClass = "tab-pane fade";
            pnlEditarCategoria.CssClass = "tab-pane fade";
            pnlEditarCategoria.Visible = false;
            pnlEliminados.CssClass = "tab-pane fade";
            pnlCategoriasEliminadas.CssClass = "tab-pane fade"; 

            // reseteamos las clases de los botones
            btnTabListado.CssClass = "nav-link";
            btnTabNuevo.CssClass = "nav-link";
            btnTabCategorias.CssClass = "nav-link";
            btnTabCategoriaNueva.CssClass = "nav-link";
            btnTabEliminados.CssClass = "nav-link";
            btnTabCategoriasEliminadas.CssClass = "nav-link"; 

            // mostramos el panel correspondiente
            switch (tab)
            {
                case "listado":
                    pnlListado.CssClass = "tab-pane fade active show";
                    btnTabListado.CssClass = "nav-link active";
                    break;
                case "nuevo":
                    pnlNuevo.CssClass = "tab-pane fade active show";
                    btnTabNuevo.CssClass = "nav-link active";
                    break;
                case "editar":
                    pnlEditar.CssClass = "tab-pane fade active show";
                    pnlEditar.Visible = true;
                    break;
                case "categorias":
                    pnlCategorias.CssClass = "tab-pane fade active show";
                    btnTabCategorias.CssClass = "nav-link active";
                    break;
                case "categoriaNueva":
                    pnlCategoriaNueva.CssClass = "tab-pane fade active show";
                    btnTabCategoriaNueva.CssClass = "nav-link active";
                    break;
                case "editarCategoria":
                    pnlEditarCategoria.CssClass = "tab-pane fade active show";
                    pnlEditarCategoria.Visible = true;
                    break;
                case "eliminados":
                    pnlEliminados.CssClass = "tab-pane fade active show";
                    btnTabEliminados.CssClass = "nav-link active";
                    break;
                case "categoriasEliminadas":
                    pnlCategoriasEliminadas.CssClass = "tab-pane fade active show";
                    btnTabCategoriasEliminadas.CssClass = "nav-link active";
                    break;
            }

            UpdatePanelContenido.Update();
        }

        protected void RepeaterProductosEliminados_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Reactivar")
            {
                try
                {
                    int id = int.Parse(e.CommandArgument.ToString());
                    ProductoService service = new ProductoService();
                    service.Reactivar(id);

                    // Recargamos ambas listas
                    CargarProductosEliminados();
                    CargarProductos();

                    MostrarMensaje("Producto reactivado correctamente.", "success");
                }
                catch (Exception ex)
                {
                    MostrarMensaje("Error al reactivar producto: " + ex.Message, "error");
                }
            }
        }

        
        private void CargarCategoriasEliminadas()
        {
            CategoriaService categoriaService = new CategoriaService();
            List<Categoria> listaEliminadas = categoriaService.ListarEliminadas();
            RepeaterCategoriasEliminadas.DataSource = listaEliminadas;
            RepeaterCategoriasEliminadas.DataBind();
        }

        protected void btnTabCategoriasEliminadas_Click(object sender, EventArgs e)
        {
            CargarCategoriasEliminadas();
            MostrarTab("categoriasEliminadas");
            OcultarMensaje();
        }

        protected void RepeaterCategoriasEliminadas_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ReactivarCategoria")
            {
                try
                {
                    int id = int.Parse(e.CommandArgument.ToString());
                    CategoriaService service = new CategoriaService();
                    service.Reactivar(id);

                    // recargamos todas las listas de categorías
                    CargarCategoriasEliminadas();
                    CargarCategorias();
                    CargarCategoriasEditar();
                    CargarListadoCategorias();
                    CargarFiltroCategoria();
                    MostrarMensaje("Categoría reactivada correctamente.", "success");
                }
                catch (Exception ex)
                {
                    MostrarMensaje("Error al reactivar categoría: " + ex.Message, "error");
                }
            }
        }



        protected void btnAceptarEliminar_Click(object sender, EventArgs e)
        {
            int id = int.Parse(hfIdEliminar.Value);
            string tipo = hfTipoEliminar.Value;

            if (tipo == "producto")
            {
                try
                {
                    ProductoService service = new ProductoService();
                    service.Eliminar(id);
                    CargarProductos();
                    if (pnlEliminados.CssClass.Contains("active"))
                    {
                        CargarProductosEliminados();
                    }
                    MostrarMensaje("Producto eliminado correctamente.", "success");
                }
                catch (Exception ex)
                {
                    MostrarMensaje(ex.Message, "warning");
                }
            }
            else if (tipo == "categoria")
            {
                try
                {
                    CategoriaService service = new CategoriaService();
                    service.Eliminar(id);
                    CargarCategorias();
                    CargarCategoriasEditar();
                    CargarListadoCategorias();
                    CargarFiltroCategoria();
                    // Si estamos en la solapa de eliminadas, la recargamos también
                    if (pnlCategoriasEliminadas.CssClass.Contains("active"))
                    {
                        CargarCategoriasEliminadas();
                    }
                    MostrarMensaje("Categoría eliminada correctamente.", "success");
                }
                catch (Exception ex)
                {
                    MostrarMensaje("Error al eliminar categoría: " + ex.Message, "error");
                }
            }

            pnlConfirmarEliminar.Visible = false;
        }


        protected void txtBuscarProducto_TextChanged(object sender, EventArgs e)
        {
            CargarProductos();
        }

        protected void ddlOrdenamiento_SelectedIndexChanged(object sender, EventArgs e)
        {
            CargarProductos();
        }

        







        private void CargarFiltroCategoria()
        {
            CategoriaService categoriaService = new CategoriaService();
            List<Categoria> categorias = categoriaService.Listar();
            ddlFiltroCategoria.DataSource = categorias;
            ddlFiltroCategoria.DataTextField = "Nombre";
            ddlFiltroCategoria.DataValueField = "CategoriaId";
            ddlFiltroCategoria.DataBind();
            ddlFiltroCategoria.Items.Insert(0, new ListItem("Todas las categorías", "0"));
        }

        

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["usuarioLoggeado"] == null)
                {
                    Response.Redirect("~/Login.aspx");
                    return;
                }

                Usuario usuarioLoggeado = (Usuario)Session["usuarioLoggeado"];

                if(usuarioLoggeado.Rol == "mesero")
                {
                    btnTabNuevo.Visible = false;
                    btnTabCategoriaNueva.Visible = false;
                    btnTabEliminados.Visible = false;
                    btnTabCategoriasEliminadas.Visible = false;
                }
                CargarFiltroCategoria(); 
                CargarCategorias();
                CargarCategoriasEditar();
                CargarListadoCategorias();
                CargarProductos(); 
            }
        }

        private void CargarProductos()
        {
            ProductoService productoService = new ProductoService();
            string textoBusqueda = txtBuscarProducto.Text.Trim();
            string ordenamiento = ddlOrdenamiento.SelectedValue;
            int categoriaId = int.Parse(ddlFiltroCategoria.SelectedValue);

            Usuario usuarioLoggeado = (Usuario)Session["usuarioLoggeado"];

           


            List<Producto> listaProductos = productoService.BuscarYFiltrar(textoBusqueda, ordenamiento, categoriaId);
            RepeaterProductos.DataSource = listaProductos;

            if (usuarioLoggeado.Rol == "mesero")
            {
                RepeaterProductos.Columns[3].Visible = false;
            }

            RepeaterProductos.DataBind();
        }

        protected void ddlFiltroCategoria_SelectedIndexChanged(object sender, EventArgs e)
        {
            CargarProductos();
        }

        protected void btnLimpiarFiltros_Click(object sender, EventArgs e)
        {
            txtBuscarProducto.Text = string.Empty;
            ddlOrdenamiento.SelectedIndex = 0;
            ddlFiltroCategoria.SelectedIndex = 0; 
            CargarProductos();
        }

        protected void RepeaterCategorias_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ConfirmarEliminarCategoria")
            {
                hfIdEliminar.Value = e.CommandArgument.ToString();
                hfTipoEliminar.Value = "categoria";
                lblConfirmarMensaje.Text = "¿Seguro que desea eliminar esta categoría?";
                pnlConfirmarEliminar.Visible = true;
            }
            else if (e.CommandName == "Eliminar")
            {
                try
                {
                    int id = int.Parse(e.CommandArgument.ToString());
                    CategoriaService service = new CategoriaService();
                    service.Eliminar(id);
                    CargarCategorias();
                    CargarCategoriasEditar();
                    CargarListadoCategorias();
                    MostrarMensaje("Categoría eliminada correctamente", "success");
                }
                catch (Exception ex)
                {
                    MostrarMensaje("Error al eliminar categoría: " + ex.Message, "error");
                }
            }
            else if (e.CommandName == "EditarCategoria")
            {
                try
                {
                    int id = int.Parse(e.CommandArgument.ToString());
                    CategoriaService service = new CategoriaService();
                    List<Categoria> categorias = service.Listar();
                    Categoria categoria = categorias.FirstOrDefault(c => c.CategoriaId == id);

                    if (categoria != null)
                    {
                        hfCategoriaId.Value = categoria.CategoriaId.ToString();
                        txtNombreCategoriaEditar.Text = categoria.Nombre;

                        MostrarTab("editarCategoria");
                        OcultarMensaje();
                    }
                }
                catch (Exception ex)
                {
                    MostrarMensaje("Error al cargar categoría: " + ex.Message, "error");
                }
            }
        }

        protected void RepeaterProductos_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ConfirmarEliminarProducto")
            {
                hfIdEliminar.Value = e.CommandArgument.ToString();
                hfTipoEliminar.Value = "producto";
                lblConfirmarMensaje.Text = "¿Seguro que desea eliminar este producto?";
                pnlConfirmarEliminar.Visible = true;
            }
            else if (e.CommandName == "Eliminar")
            {
                try
                {
                    int id = int.Parse(e.CommandArgument.ToString());
                    ProductoService service = new ProductoService();
                    service.Eliminar(id);
                    CargarProductos();
                    MostrarMensaje("Producto eliminado correctamente", "success");
                }
                catch (Exception ex)
                {
                    MostrarMensaje("Error al eliminar producto: " + ex.Message, "error");
                }
            }
            else if (e.CommandName == "Editar")
            {
                try
                {
                    int id = int.Parse(e.CommandArgument.ToString());
                    ProductoService service = new ProductoService();
                    List<Producto> productos = service.Listar();
                    Producto producto = productos.FirstOrDefault(p => p.ProductoId == id);

                    if (producto != null)
                    {
                        CargarCategoriasEditar();

                        hfProductoId.Value = producto.ProductoId.ToString();
                        txtNombreEditar.Text = producto.Nombre;
                        txtCantidadEditar.Text = producto.Stock.ToString();
                        txtPrecioEditar.Text = producto.Precio.ToString();
                        ddlCategoriasEditar.SelectedValue = producto.CategoriaId.ToString();

                        MostrarTab("editar");
                        OcultarMensaje();
                    }
                }
                catch (Exception ex)
                {
                    MostrarMensaje("Error al cargar producto: " + ex.Message, "error");
                }
            }
        }
    }
}