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
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarProductos();
                CargarCategorias();
                CargarCategoriasEditar();
                CargarListadoCategorias();
            }
        }

        private void CargarProductos()
        {
            ProductoService productoService = new ProductoService();
            List<Producto> listaProductos = productoService.Listar();
            RepeaterProductos.DataSource = listaProductos;
            RepeaterProductos.DataBind();
        }

        private void CargarCategorias()
        {
            CategoriaService categoriaService = new CategoriaService();
            List<Categoria> categorias = categoriaService.Listar();
            ddlCategorias.DataSource = categorias;
            ddlCategorias.DataTextField = "Nombre";
            ddlCategorias.DataValueField = "CategoriaId";
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

        // ========== SISTEMA DE MENSAJES ==========
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

        // ========== NAVEGACIÓN ENTRE TABS ==========
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

        private void MostrarTab(string tab)
        {
            // Ocultamos los paneles
            pnlListado.CssClass = "tab-pane fade";
            pnlNuevo.CssClass = "tab-pane fade";
            pnlEditar.CssClass = "tab-pane fade";
            pnlEditar.Visible = false;
            pnlCategorias.CssClass = "tab-pane fade";
            pnlCategoriaNueva.CssClass = "tab-pane fade";

            // reseteamos clases de los botones
            btnTabListado.CssClass = "nav-link";
            btnTabNuevo.CssClass = "nav-link";
            btnTabCategorias.CssClass = "nav-link";
            btnTabCategoriaNueva.CssClass = "nav-link";

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
                    btnTabListado.CssClass = "nav-link";
                    break;
                case "categorias":
                    pnlCategorias.CssClass = "tab-pane fade active show";
                    btnTabCategorias.CssClass = "nav-link active";
                    break;
                case "categoriaNueva":
                    pnlCategoriaNueva.CssClass = "tab-pane fade active show";
                    btnTabCategoriaNueva.CssClass = "nav-link active";
                    break;
            }

            UpdatePanelContenido.Update();
        }

        
        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
                int categoriaId = int.Parse(ddlCategorias.SelectedValue);

                if (categoriaId == 0)
                {
                    MostrarMensaje("Por favor seleccione una categoría", "warning");
                    return;
                }

                Producto nuevo = new Producto();
                nuevo.Nombre = txtNombre.Text.Trim();
                nuevo.Stock = int.Parse(txtCantidad.Text.Trim());
                nuevo.Precio = decimal.Parse(txtPrecio.Text.Trim());
                nuevo.Disponible = true;
                nuevo.CategoriaId = categoriaId;

                ProductoService service = new ProductoService();
                service.Agregar(nuevo);

                // limpiamos los campos
                txtNombre.Text = "";
                txtCantidad.Text = "";
                txtPrecio.Text = "";
                ddlCategorias.SelectedIndex = 0;

                CargarProductos();
                MostrarMensaje("Producto agregado correctamente", "success");
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
                Producto producto = new Producto();
                producto.ProductoId = int.Parse(hfProductoId.Value);
                producto.Nombre = txtNombreEditar.Text.Trim();
                producto.Stock = int.Parse(txtCantidadEditar.Text.Trim());
                producto.Precio = decimal.Parse(txtPrecioEditar.Text.Trim());
                producto.CategoriaId = int.Parse(ddlCategoriasEditar.SelectedValue);
                producto.Disponible = true;

                ProductoService service = new ProductoService();
                service.Modificar(producto);

                LimpiarFormularioEditar();
                CargarProductos();
                MostrarTab("listado");
                MostrarMensaje("Producto actualizado correctamente", "success");
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

        
        protected void RepeaterProductos_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Eliminar")
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
                service.Agregar(nueva);

                txtNombreCategoria.Text = "";
                CargarCategorias();
                CargarCategoriasEditar();
                CargarListadoCategorias();
                MostrarMensaje("Categoría agregada correctamente", "success");
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al agregar categoría: " + ex.Message, "error");
            }
        }

        
        protected void RepeaterCategorias_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Eliminar")
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
        }
    }
}