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

        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            string nombre = txtNombre.Text.Trim();
            string descripcion = txtDescripcion.Text.Trim();
            int cantidad;

            if (int.TryParse(txtCantidad.Text, out cantidad))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert","alert('Producto agregado correctamente.');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert","alert('Por favor, ingrese una cantidad válida.');", true);
            }
        }


    }
}