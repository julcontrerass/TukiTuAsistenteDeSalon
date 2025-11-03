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


        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
                Producto nuevo = new Producto();
                nuevo.Nombre = txtNombre.Text.Trim();
                nuevo.Stock = int.Parse(txtCantidad.Text.Trim());
                nuevo.Precio = decimal.Parse(txtPrecio.Text.Trim());
                nuevo.Disponible = true;

                int categoriaId = int.Parse(ddlCategorias.SelectedValue);

                if (categoriaId == 0)
                {
                    //acá debo poner una ventana emergente que diga "Por favor seleccione una categoría"
                    return;
                }

                nuevo.CategoriaId = categoriaId;

                ProductoService service = new ProductoService();
                service.Agregar(nuevo);

                //acá debo poner una ventana emergente que diga "Producto agregado correctamente"

                // actualizamos la lista
                CargarProductos();
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", $"alert('Error al agregar producto: {ex.Message}');", true);
            }
        }




        protected void RepeaterProductos_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Eliminar")
            {
                int id = int.Parse(e.CommandArgument.ToString());
                ProductoService service = new ProductoService();
                service.Eliminar(id);

                // Refrescamos la lista
                CargarProductos();

                //aca debo poner una ventana emergente que diga "Producto eliminado correctamente"
            }
        }




    }
}