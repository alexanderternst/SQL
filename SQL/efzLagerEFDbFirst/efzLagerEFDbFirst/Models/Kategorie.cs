using System;
using System.Collections.Generic;

namespace efzLagerEFDbFirst.Models
{
    public partial class Kategorie
    {
        public Kategorie()
        {
            Unterkategories = new HashSet<Unterkategorie>();
        }

        public string Kategorie1 { get; set; } = null!;
        public int KategorieId { get; set; }

        public virtual ICollection<Unterkategorie> Unterkategories { get; set; }
    }
}
