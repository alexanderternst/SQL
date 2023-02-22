using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

namespace efzLagerEFDbFirst.Models
{
    public partial class efzLagerContext : DbContext
    {
        public efzLagerContext()
        {
        }

        public efzLagerContext(DbContextOptions<efzLagerContext> options)
            : base(options)
        {
        }

        public virtual DbSet<Artikel> Artikels { get; set; } = null!;
        public virtual DbSet<ArtikelImport> ArtikelImports { get; set; } = null!;
        public virtual DbSet<ArtikelLager> ArtikelLagers { get; set; } = null!;
        public virtual DbSet<Einkauf> Einkaufs { get; set; } = null!;
        public virtual DbSet<Kategorie> Kategories { get; set; } = null!;
        public virtual DbSet<Lagerort> Lagerorts { get; set; } = null!;
        public virtual DbSet<Lieferant> Lieferants { get; set; } = null!;
        public virtual DbSet<Unterkategorie> Unterkategories { get; set; } = null!;
        public virtual DbSet<Verkaufsprei> Verkaufspreis { get; set; } = null!;
        public virtual DbSet<Waehrung> Waehrungs { get; set; } = null!;

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
                optionsBuilder.UseSqlServer("Server=ALEXANDERPC;Database=efzLager;Trusted_Connection=True;");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Artikel>(entity =>
            {
                entity.ToTable("Artikel", "lager");

                entity.HasIndex(e => e.Artikel1, "UNQ_Artikel")
                    .IsUnique();

                entity.Property(e => e.ArtikelId).HasColumnName("Artikel_ID");

                entity.Property(e => e.Artikel1)
                    .HasMaxLength(255)
                    .IsUnicode(false)
                    .HasColumnName("Artikel");

                entity.Property(e => e.Farbe)
                    .HasMaxLength(255)
                    .IsUnicode(false);

                entity.Property(e => e.UnterkategorieId).HasColumnName("Unterkategorie_ID");

                entity.HasOne(d => d.Unterkategorie)
                    .WithMany(p => p.Artikels)
                    .HasForeignKey(d => d.UnterkategorieId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("Artikel_Unterkategorie");
            });

            modelBuilder.Entity<ArtikelImport>(entity =>
            {
                entity.HasNoKey();

                entity.ToTable("ArtikelImport");

                entity.Property(e => e.Color).HasMaxLength(15);

                entity.Property(e => e.EnglishProductCategoryName).HasMaxLength(50);

                entity.Property(e => e.EnglishProductName).HasMaxLength(50);

                entity.Property(e => e.EnglishProductSubcategoryName).HasMaxLength(50);

                entity.Property(e => e.PriceEur)
                    .HasColumnType("money")
                    .HasColumnName("PriceEUR");

                entity.Property(e => e.PriceUsd)
                    .HasColumnType("money")
                    .HasColumnName("PriceUSD");
            });

            modelBuilder.Entity<ArtikelLager>(entity =>
            {
                entity.HasKey(e => new { e.ArtikelId, e.LagerortId })
                    .HasName("ArtikelLager_pk");

                entity.ToTable("ArtikelLager", "lager");

                entity.Property(e => e.ArtikelId).HasColumnName("Artikel_ID");

                entity.Property(e => e.LagerortId).HasColumnName("Lagerort_ID");

                entity.HasOne(d => d.Artikel)
                    .WithMany(p => p.ArtikelLagers)
                    .HasForeignKey(d => d.ArtikelId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("ArtikelLager_Artikel");

                entity.HasOne(d => d.Lagerort)
                    .WithMany(p => p.ArtikelLagers)
                    .HasForeignKey(d => d.LagerortId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("ArtikelLager_Lagerort");
            });

            modelBuilder.Entity<Einkauf>(entity =>
            {
                entity.HasKey(e => new { e.ArtikelId, e.LieferantId })
                    .HasName("Einkauf_pk");

                entity.ToTable("Einkauf", "lager");

                entity.Property(e => e.ArtikelId).HasColumnName("Artikel_ID");

                entity.Property(e => e.LieferantId).HasColumnName("Lieferant_ID");

                entity.Property(e => e.Einkaufspreis).HasColumnType("decimal(10, 5)");

                entity.Property(e => e.WaehrungsId).HasColumnName("Waehrungs_ID");

                entity.HasOne(d => d.Artikel)
                    .WithMany(p => p.Einkaufs)
                    .HasForeignKey(d => d.ArtikelId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("Einkauf_Artikel");

                entity.HasOne(d => d.Lieferant)
                    .WithMany(p => p.Einkaufs)
                    .HasForeignKey(d => d.LieferantId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("Einkauf_Lieferant");

                entity.HasOne(d => d.Waehrungs)
                    .WithMany(p => p.Einkaufs)
                    .HasForeignKey(d => d.WaehrungsId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("Einkauf_Waehrung");
            });

            modelBuilder.Entity<Kategorie>(entity =>
            {
                entity.ToTable("Kategorie", "lager");

                entity.HasIndex(e => e.Kategorie1, "UNQ_Kategorie")
                    .IsUnique();

                entity.Property(e => e.KategorieId).HasColumnName("Kategorie_ID");

                entity.Property(e => e.Kategorie1)
                    .HasMaxLength(255)
                    .IsUnicode(false)
                    .HasColumnName("Kategorie");
            });

            modelBuilder.Entity<Lagerort>(entity =>
            {
                entity.ToTable("Lagerort", "lager");

                entity.HasIndex(e => e.Lagerort1, "UNQ_Lagerort")
                    .IsUnique();

                entity.Property(e => e.LagerortId).HasColumnName("Lagerort_ID");

                entity.Property(e => e.Lagerort1)
                    .HasMaxLength(255)
                    .IsUnicode(false)
                    .HasColumnName("Lagerort");
            });

            modelBuilder.Entity<Lieferant>(entity =>
            {
                entity.ToTable("Lieferant", "lager");

                entity.HasIndex(e => e.Lieferant1, "UNQ_Lieferant")
                    .IsUnique();

                entity.Property(e => e.LieferantId).HasColumnName("Lieferant_ID");

                entity.Property(e => e.Lieferant1)
                    .HasMaxLength(255)
                    .IsUnicode(false)
                    .HasColumnName("Lieferant");
            });

            modelBuilder.Entity<Unterkategorie>(entity =>
            {
                entity.ToTable("Unterkategorie", "lager");

                entity.HasIndex(e => e.Unterkategorie1, "UNQ_Unterkategorie")
                    .IsUnique();

                entity.Property(e => e.UnterkategorieId).HasColumnName("Unterkategorie_ID");

                entity.Property(e => e.KategorieId).HasColumnName("Kategorie_ID");

                entity.Property(e => e.Unterkategorie1)
                    .HasMaxLength(255)
                    .IsUnicode(false)
                    .HasColumnName("Unterkategorie");

                entity.HasOne(d => d.Kategorie)
                    .WithMany(p => p.Unterkategories)
                    .HasForeignKey(d => d.KategorieId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("Unterkategorie_Kategorie");
            });

            modelBuilder.Entity<Verkaufsprei>(entity =>
            {
                entity.HasKey(e => new { e.WaehrungsId, e.ArtikelId })
                    .HasName("Verkaufspreis_pk");

                entity.ToTable("Verkaufspreis", "lager");

                entity.Property(e => e.WaehrungsId).HasColumnName("Waehrungs_ID");

                entity.Property(e => e.ArtikelId).HasColumnName("Artikel_ID");

                entity.Property(e => e.Verkaufspreis).HasColumnType("decimal(10, 5)");

                entity.HasOne(d => d.Artikel)
                    .WithMany(p => p.Verkaufspreis)
                    .HasForeignKey(d => d.ArtikelId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("Verkaufspreis_Artikel");

                entity.HasOne(d => d.Waehrungs)
                    .WithMany(p => p.Verkaufspreis)
                    .HasForeignKey(d => d.WaehrungsId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("Verkaufspreis_Waehrung");
            });

            modelBuilder.Entity<Waehrung>(entity =>
            {
                entity.HasKey(e => e.WaehrungsId)
                    .HasName("Waehrung_pk");

                entity.ToTable("Waehrung", "lager");

                entity.HasIndex(e => e.Waehrung1, "UNQ_Waehrung")
                    .IsUnique();

                entity.Property(e => e.WaehrungsId).HasColumnName("Waehrungs_ID");

                entity.Property(e => e.Waehrung1)
                    .HasMaxLength(255)
                    .IsUnicode(false)
                    .HasColumnName("Waehrung");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
