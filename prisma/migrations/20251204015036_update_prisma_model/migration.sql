/*
  Warnings:

  - You are about to drop the column `endTime` on the `Bookings` table. All the data in the column will be lost.
  - You are about to drop the column `isDeleted` on the `Bookings` table. All the data in the column will be lost.
  - You are about to drop the column `requestedAt` on the `Bookings` table. All the data in the column will be lost.
  - You are about to drop the column `startTime` on the `Bookings` table. All the data in the column will be lost.
  - You are about to drop the column `avgRating` on the `Listings` table. All the data in the column will be lost.
  - You are about to drop the column `isDeleted` on the `Listings` table. All the data in the column will be lost.
  - You are about to drop the column `price` on the `Listings` table. All the data in the column will be lost.
  - You are about to drop the column `totalReviews` on the `Listings` table. All the data in the column will be lost.
  - You are about to drop the column `tourLanguage` on the `Listings` table. All the data in the column will be lost.
  - The `category` column on the `Listings` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - You are about to drop the column `isDeleted` on the `Payments` table. All the data in the column will be lost.
  - You are about to drop the column `method` on the `Payments` table. All the data in the column will be lost.
  - You are about to drop the column `providerPayload` on the `Payments` table. All the data in the column will be lost.
  - The `status` column on the `Payments` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - You are about to drop the column `isDeleted` on the `Reviews` table. All the data in the column will be lost.
  - You are about to drop the column `avgRating` on the `Users` table. All the data in the column will be lost.
  - You are about to drop the column `isDeleted` on the `Users` table. All the data in the column will be lost.
  - You are about to drop the column `languages` on the `Users` table. All the data in the column will be lost.
  - You are about to drop the column `profileImage` on the `Users` table. All the data in the column will be lost.
  - You are about to drop the column `totalReviews` on the `Users` table. All the data in the column will be lost.
  - You are about to drop the `Wishlists` table. If the table is not empty, all the data it contains will be lost.
  - A unique constraint covering the columns `[bookingId]` on the table `Reviews` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `bookingDate` to the `Bookings` table without a default value. This is not possible if the table is not empty.
  - Added the required column `totalAmount` to the `Bookings` table without a default value. This is not possible if the table is not empty.
  - Added the required column `city` to the `Listings` table without a default value. This is not possible if the table is not empty.
  - Added the required column `tourFee` to the `Listings` table without a default value. This is not possible if the table is not empty.
  - Added the required column `paymentMethod` to the `Payments` table without a default value. This is not possible if the table is not empty.
  - Added the required column `receiverId` to the `Payments` table without a default value. This is not possible if the table is not empty.
  - Added the required column `senderId` to the `Payments` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updatedAt` to the `Payments` table without a default value. This is not possible if the table is not empty.
  - Added the required column `bookingId` to the `Reviews` table without a default value. This is not possible if the table is not empty.
  - Added the required column `guideId` to the `Reviews` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "PaymentStatus" AS ENUM ('PENDING', 'COMPLETED', 'FAILED');

-- DropForeignKey
ALTER TABLE "Wishlists" DROP CONSTRAINT "Wishlists_listingId_fkey";

-- DropForeignKey
ALTER TABLE "Wishlists" DROP CONSTRAINT "Wishlists_userId_fkey";

-- AlterTable
ALTER TABLE "Bookings" DROP COLUMN "endTime",
DROP COLUMN "isDeleted",
DROP COLUMN "requestedAt",
DROP COLUMN "startTime",
ADD COLUMN     "bookingDate" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "numberOfPeople" INTEGER NOT NULL DEFAULT 1,
ADD COLUMN     "totalAmount" DOUBLE PRECISION NOT NULL;

-- AlterTable
ALTER TABLE "Listings" DROP COLUMN "avgRating",
DROP COLUMN "isDeleted",
DROP COLUMN "price",
DROP COLUMN "totalReviews",
DROP COLUMN "tourLanguage",
ADD COLUMN     "averageRating" DOUBLE PRECISION NOT NULL DEFAULT 0,
ADD COLUMN     "city" TEXT NOT NULL,
ADD COLUMN     "isActive" BOOLEAN NOT NULL DEFAULT true,
ADD COLUMN     "totalBookings" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "tourFee" DOUBLE PRECISION NOT NULL,
ALTER COLUMN "images" SET DEFAULT ARRAY[]::TEXT[],
DROP COLUMN "category",
ADD COLUMN     "category" TEXT[] DEFAULT ARRAY[]::TEXT[];

-- AlterTable
ALTER TABLE "Payments" DROP COLUMN "isDeleted",
DROP COLUMN "method",
DROP COLUMN "providerPayload",
ADD COLUMN     "paymentMethod" TEXT NOT NULL,
ADD COLUMN     "receiverId" TEXT NOT NULL,
ADD COLUMN     "senderId" TEXT NOT NULL,
ADD COLUMN     "updatedAt" TIMESTAMP(3) NOT NULL,
DROP COLUMN "status",
ADD COLUMN     "status" "PaymentStatus" NOT NULL DEFAULT 'PENDING';

-- AlterTable
ALTER TABLE "Reviews" DROP COLUMN "isDeleted",
ADD COLUMN     "bookingId" TEXT NOT NULL,
ADD COLUMN     "guideId" TEXT NOT NULL,
ALTER COLUMN "rating" SET DATA TYPE DOUBLE PRECISION;

-- AlterTable
ALTER TABLE "Users" DROP COLUMN "avgRating",
DROP COLUMN "isDeleted",
DROP COLUMN "languages",
DROP COLUMN "profileImage",
DROP COLUMN "totalReviews",
ADD COLUMN     "averageRating" DOUBLE PRECISION NOT NULL DEFAULT 0,
ADD COLUMN     "languagesSpoken" TEXT[] DEFAULT ARRAY[]::TEXT[],
ADD COLUMN     "profilePicture" TEXT,
ADD COLUMN     "totalTours" INTEGER NOT NULL DEFAULT 0,
ALTER COLUMN "expertise" SET DEFAULT ARRAY[]::TEXT[],
ALTER COLUMN "travelPreferences" SET DEFAULT ARRAY[]::TEXT[];

-- DropTable
DROP TABLE "Wishlists";

-- CreateIndex
CREATE UNIQUE INDEX "Reviews_bookingId_key" ON "Reviews"("bookingId");

-- AddForeignKey
ALTER TABLE "Reviews" ADD CONSTRAINT "Reviews_bookingId_fkey" FOREIGN KEY ("bookingId") REFERENCES "Bookings"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Reviews" ADD CONSTRAINT "Reviews_guideId_fkey" FOREIGN KEY ("guideId") REFERENCES "Users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Payments" ADD CONSTRAINT "Payments_senderId_fkey" FOREIGN KEY ("senderId") REFERENCES "Users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Payments" ADD CONSTRAINT "Payments_receiverId_fkey" FOREIGN KEY ("receiverId") REFERENCES "Users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
