using System;
using System.Collections.Generic;

namespace efzLagerEFDbFirst.Models
{
    public partial class Unterkategorie
    {
        public Unterkategorie()
        {
            Artikels = new HashSet<Artikel>();
        }

        public int UnterkategorieId { get; set; }
        public string Unterkategorie1 { get; set; } = null!;
        public int KategorieId { get; set; }

        public virtual Kategorie Kategorie { get; set; } = null!;
        public virtual ICollection<Artikel> Artikels { get; set; }
    }
}
