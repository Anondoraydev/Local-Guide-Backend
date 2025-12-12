import bcrypt from "bcryptjs";
import dbConfig from "../config/db.config";
import { prisma } from "../config/prisma";
import { UserRole } from "../generated/prisma/enums";

export const seedSuperAdmin = async () => {
  try {
    const existingAdmin = await prisma.user.findUnique({
      where: { email: dbConfig.superAdmin.email },
    });

    if (existingAdmin) {
      console.log("Super Admin Already Exists!");
      return;
    }

    console.log("Creating Super Admin...");

    const hashedPassword = await bcrypt.hash(
      dbConfig.superAdmin.password!,
      Number(dbConfig.bcryptJs_salt)
    );

    const superAdminData = {
      fullName: "Super Admin",
      email: dbConfig.superAdmin.email!,
      password: hashedPassword,
      role: UserRole.SUPER_ADMIN, // make sure this exists in your Prisma enum
      verifiedBadge: true,
      interests: ["Management", "All"], // if in schema: string[] or Json
      visitedCountries: ["Bangladesh"], // if in schema: string[] or Json
      isPublic: false,
    };

    const superAdmin = await prisma.user.create({
      data: superAdminData,
    });

    console.log("Super Admin created successfully!");
    console.log(superAdmin);
  } catch (error) {
    console.error("Error seeding Super Admin:", error);
  } finally {
    await prisma.$disconnect();
  }
};
