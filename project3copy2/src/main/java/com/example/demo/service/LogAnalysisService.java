package com.example.demo.service;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.io.*;
import java.nio.file.*;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class LogAnalysisService {

    private static final String LOG_DIR = "logs/";
    private static final String OUTPUT_FILE = "logs/error-summary.txt";

    @Scheduled(cron = "0 0 0 * * ?") // 매일 자정 실행
    public void analyzeLogs() {
        try {
            List<String> errorLogs = new ArrayList<>();
            Files.list(Paths.get(LOG_DIR))
                    .filter(path -> path.toString().endsWith(".log"))
                    .forEach(file -> {
                        try (BufferedReader reader = new BufferedReader(new FileReader(file.toFile()))) {
                            errorLogs.addAll(reader.lines()
                                    .filter(line -> line.contains("ERROR"))
                                    .collect(Collectors.toList()));
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    });

            writeSummary(errorLogs);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void writeSummary(List<String> errorLogs) throws IOException {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(OUTPUT_FILE))) {
            writer.write("Error Log Summary\n");
            writer.write("=================\n");
            for (String log : errorLogs) {
                writer.write(log);
                writer.newLine();
            }
        }
        System.out.println("Error summary saved to " + OUTPUT_FILE);
    }
    
}
