using System;
using System.Collections.Generic;

namespace efzLagerEFDbFirst.Models
{
    public partial class Waehrung
    {
        public Waehrung()
        {
            Einkaufs = new HashSet<Einkauf>();
            Verkaufspreis = new HashSet<Verkaufsprei>();
        }

        public int WaehrungsId { get; set; }
        public string Waehrung1 { get; set; } = null!;

        public virtual ICollection<Einkauf> Einkaufs { get; set; }
        public virtual ICollection<Verkaufsprei> Verkaufspreis { get; set; }
    }
}
