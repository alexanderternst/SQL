using System;
using System.Collections.Generic;

namespace efzLagerEFDbFirst.Models
{
    public partial class Artikel
    {
        public Artikel()
        {
            ArtikelLagers = new HashSet<ArtikelLager>();
            Einkaufs = new HashSet<Einkauf>();
            Verkaufspreis = new HashSet<Verkaufsprei>();
        }

        public int ArtikelId { get; set; }
        public string Artikel1 { get; set; } = null!;
        public int Mindestbestand { get; set; }
        public int UnterkategorieId { get; set; }
        public string Farbe { get; set; } = null!;

        public virtual Unterkategorie Unterkategorie { get; set; } = null!;
        public virtual ICollection<ArtikelLager> ArtikelLagers { get; set; }
        public virtual ICollection<Einkauf> Einkaufs { get; set; }
        public virtual ICollection<Verkaufsprei> Verkaufspreis { get; set; }
    }
}
