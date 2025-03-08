-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Feb 10, 2025 at 09:19 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `bind`
--

-- --------------------------------------------------------

--
-- Table structure for table `data`
--

CREATE TABLE `data` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `mood` varchar(50) NOT NULL,
  `data` text NOT NULL,
  `date` date NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `data`
--

INSERT INTO `data` (`id`, `user_id`, `mood`, `data`, `date`) VALUES
(3, 1, 'disappointed', 'Dtjrjuet5uhje67tuj7iu', '2025-02-08'),
(12, 1, 'happy', 'My test was a success and there are no issues in my app mostly\n', '2025-02-10'),
(14, 1, 'sad', 'I was a bit sad as i was unable to check my speech  to text function wether it is working or not due to lack of an ios phone and it cant be checked in ios emulator', '2025-02-10');

-- --------------------------------------------------------

--
-- Table structure for table `events`
--

CREATE TABLE `events` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `event_date` date NOT NULL,
  `priority` enum('High','Medium','Low') NOT NULL DEFAULT 'Medium'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `events`
--

INSERT INTO `events` (`id`, `user_id`, `title`, `description`, `event_date`, `priority`) VALUES
(5, 1, 'Wow', 'I am so happy as my created event is fully functional', '2025-02-28', 'Low'),
(6, 1, 'Check', 'This was just a checking purpose wether the event cards are displayed according to the upcoming nearest date r not \n\n\n\n\n\n\n\n\n\n\n\n\nDkjrbgdkntjkgrt\n\n\n\n\n\n\nErjbfejkrnge\n\n\n\n\nWrong Jorginho\n\n\n\nJkbnrtkjhn', '2025-02-09', 'High'),
(8, 1, 'Trial', 'DBS FD FHH fgvhnfhyvffg', '2025-02-28', 'Low');

-- --------------------------------------------------------

--
-- Table structure for table `quotes`
--

CREATE TABLE `quotes` (
  `id` int(11) NOT NULL,
  `quote` text NOT NULL,
  `author` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `quotes`
--

INSERT INTO `quotes` (`id`, `quote`, `author`) VALUES
(1, 'Courage doesn’t always roar. Sometimes it’s the small voice at the end of the day whispering, ‘I will try again tomorrow.’ Strength is found in persistence.', 'Mary Anne Radmacher'),
(2, 'The only way to do great work is to love what you do. Don’t settle. As with all matters of the heart, you’ll know when you find it.', 'Steve Jobs'),
(3, 'Life is what happens when you’re busy making other plans. Sometimes we get caught up in planning and forget to live in the moment.', 'John Lennon'),
(4, 'Get busy living or get busy dying. Life is short, and the time to live your dreams is now, not tomorrow or next year.', 'Stephen King'),
(5, 'You miss 100% of the shots you don’t take. Don’t let fear hold you back from going after the things you want in life.', 'Wayne Gretzky'),
(6, 'In the middle of difficulty lies opportunity. When faced with challenges, it’s often a sign that you’re on the brink of something great.', 'Albert Einstein'),
(7, 'The best way to predict the future is to create it. We have the power to shape the world we live in by the decisions we make today.', 'Abraham Lincoln'),
(8, 'To be yourself in a world that is constantly trying to make you something else is the greatest accomplishment. Authenticity is one of the hardest things to preserve.', 'Ralph Waldo Emerson'),
(9, 'Success is not the key to happiness. Happiness is the key to success. If you love what you are doing, you will be successful.', 'Albert Schweitzer'),
(10, 'Don’t watch the clock; do what it does. Keep going. Time moves forward, and so should you, without worrying about how fast or slow.', 'Sam Levenson'),
(11, 'Success is not final, failure is not fatal: It is the courage to continue that counts. The true measure of success is how you handle adversity.', 'Winston Churchill'),
(12, 'Believe you can and you’re halfway there. Confidence in yourself is the first step toward achieving your dreams.', 'Theodore Roosevelt'),
(13, 'The only impossible journey is the one you never begin. If you don’t take the first step, you’ll never know what could have been.', 'Tony Robbins'),
(14, 'Keep your face always toward the sunshine—and shadows will fall behind you. The more you focus on positivity, the less room there is for negativity.', 'Walt Whitman'),
(15, 'It does not matter how slowly you go as long as you do not stop. Progress, no matter how slow, is still progress.', 'Confucius'),
(16, 'Everything you can imagine is real. Our dreams are often the first sign of what we’re truly capable of achieving.', 'Pablo Picasso'),
(17, 'What lies behind us and what lies before us are tiny matters compared to what lies within us. The strength to change the world comes from within.', 'Ralph Waldo Emerson'),
(18, 'Dream big and dare to fail. We are often too afraid to fail, but it is failure that brings the greatest lessons and growth.', 'Norman Vaughan'),
(19, 'The future belongs to those who believe in the beauty of their dreams. Your dreams have the potential to define your future, but only if you believe in them.', 'Eleanor Roosevelt'),
(20, 'Don’t let yesterday take up too much of today. The past is behind you, and the future is yours to create.', 'Will Rogers'),
(21, 'You are never too old to set another goal or to dream a new dream. It’s never too late to chase your dreams, no matter where you are in life.', 'C.S. Lewis'),
(22, 'Opportunities don’t happen, you create them. Success isn’t about waiting for the right time; it’s about making your own opportunities.', 'Chris Grosser'),
(23, 'Success usually comes to those who are too busy to be looking for it. When you focus on doing your best, success will naturally follow.', 'Henry David Thoreau'),
(24, 'I am not a product of my circumstances. I am a product of my decisions. What happens to you doesn’t define you; how you react to it does.', 'Stephen R. Covey'),
(25, 'You can never cross the ocean until you have the courage to lose sight of the shore. It’s only by stepping into the unknown that we can grow and experience new things.', 'Christopher Columbus'),
(26, 'Hardships often prepare ordinary people for an extraordinary destiny. The most challenging experiences often lead to the most significant breakthroughs.', 'C.S. Lewis'),
(27, 'It always seems impossible until it’s done. Challenges are only impossible if you don’t have the courage to keep going.', 'Nelson Mandela'),
(28, 'The only limit to our realization of tomorrow is our doubts of today. Doubt can often prevent us from achieving our true potential.', 'Franklin D. Roosevelt'),
(29, 'Do one thing every day that scares you. Growth happens outside of our comfort zones, and by pushing yourself, you grow stronger.', 'Eleanor Roosevelt'),
(30, 'You don’t have to be great to start, but you have to start to be great. The key to greatness lies in beginning, no matter how small the steps may seem.', 'Zig Ziglar'),
(31, 'The way to get started is to quit talking and begin doing. Action speaks louder than words and is the path to success.', 'Walt Disney');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `dob` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password`, `dob`) VALUES
(1, 'test', 'test@gmail.com', '147258', '2004-08-15'),
(4, 'test3', 'test3@gmail.com', '123456', '2004-08-15'),
(5, 'test4', 'test4@gmail.com', '123456', '2004-08-15'),
(6, 'test6', 'test6@gmail.com', '123456', '2004-08-15'),
(8, 'test8', 'test8@gmail.com', '123456', '2025-02-04'),
(9, 'test9', 'test9@gmail.com', '123456', '2025-02-06'),
(10, 'test10', 'test10@gmail.com', '123456', '2004-08-15');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `data`
--
ALTER TABLE `data`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `quotes`
--
ALTER TABLE `quotes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `data`
--
ALTER TABLE `data`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `events`
--
ALTER TABLE `events`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `quotes`
--
ALTER TABLE `quotes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `data`
--
ALTER TABLE `data`
  ADD CONSTRAINT `data_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `events`
--
ALTER TABLE `events`
  ADD CONSTRAINT `events_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
