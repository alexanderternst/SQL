using System;
using System.Collections.Generic;

namespace efzLagerEFDbFirst.Models
{
    public partial class Lagerort
    {
        public Lagerort()
        {
            ArtikelLagers = new HashSet<ArtikelLager>();
        }

        public int LagerortId { get; set; }
        public string Lagerort1 { get; set; } = null!;

        public virtual ICollection<ArtikelLager> ArtikelLagers { get; set; }
    }
}
