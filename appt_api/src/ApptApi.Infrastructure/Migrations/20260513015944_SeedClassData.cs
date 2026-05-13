using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ApptApi.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class SeedClassData : Migration
    {
        private static readonly Guid ProviderId1 = new("a1000000-0000-0000-0000-000000000001");
        private static readonly Guid ProviderId2 = new("a2000000-0000-0000-0000-000000000002");
        private static readonly Guid ProviderId3 = new("a3000000-0000-0000-0000-000000000003");

        private static readonly Guid ClassId1 = new("b1000000-0000-0000-0000-000000000001");
        private static readonly Guid ClassId2 = new("b2000000-0000-0000-0000-000000000002");
        private static readonly Guid ClassId3 = new("b3000000-0000-0000-0000-000000000003");

        private static readonly DateTime Now = new(2026, 5, 13, 0, 0, 0, DateTimeKind.Utc);

        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                table: "providers",
                columns: new[] { "id", "name", "bio", "avatar_url", "specialty", "created_at", "updated_at" },
                values: new object[,]
                {
                    { ProviderId1, "Sarah Mitchell", "Certified yoga instructor with 10 years of experience.", null, "Yoga", Now, Now },
                    { ProviderId2, "James Okafor", "Former professional athlete turned HIIT coach.", null, "HIIT", Now, Now },
                    { ProviderId3, "Lena Park", "Pilates specialist focused on core strength and mobility.", null, "Pilates", Now, Now },
                });

            migrationBuilder.InsertData(
                table: "classes",
                columns: new[] { "id", "title", "provider_id", "scheduled_at", "duration_minutes", "max_capacity", "description", "created_at", "updated_at" },
                values: new object[,]
                {
                    { ClassId1, "Morning Flow Yoga", ProviderId1, Now.AddDays(1).AddHours(7), 60, 15, "A calming morning yoga session to start your day right.", Now, Now },
                    { ClassId2, "HIIT Burn", ProviderId2, Now.AddDays(1).AddHours(12), 45, 20, "High-intensity interval training to torch calories fast.", Now, Now },
                    { ClassId3, "Core Pilates", ProviderId3, Now.AddDays(2).AddHours(9), 50, 12, "Targeted Pilates session to strengthen your core and improve posture.", Now, Now },
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(table: "classes", keyColumn: "id", keyValues: new object[] { ClassId1, ClassId2, ClassId3 });
            migrationBuilder.DeleteData(table: "providers", keyColumn: "id", keyValues: new object[] { ProviderId1, ProviderId2, ProviderId3 });
        }
    }
}
