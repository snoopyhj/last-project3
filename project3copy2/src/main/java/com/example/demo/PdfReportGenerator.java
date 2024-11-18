package com.example.demo;

import org.apache.pdfbox.pdmodel.*;
import org.apache.pdfbox.pdmodel.common.PDRectangle;
import org.apache.pdfbox.pdmodel.font.PDType1Font;

import java.io.*;
import java.util.List;

public class PdfReportGenerator {

    public void generatePdf(List<String> logs, String outputFile) {
        try (PDDocument document = new PDDocument()) {
            PDPage page = new PDPage(PDRectangle.A4);
            document.addPage(page);

            try (PDPageContentStream contentStream = new PDPageContentStream(document, page)) {
                contentStream.setFont(PDType1Font.HELVETICA, 12);
                contentStream.beginText();
                contentStream.setLeading(14.5f);
                contentStream.newLineAtOffset(50, 750);

                contentStream.showText("Error Log Summary");
                contentStream.newLine();
                contentStream.showText("=================");
                contentStream.newLine();
                contentStream.newLine();

                for (String log : logs) {
                    contentStream.showText(log);
                    contentStream.newLine();
                }

                contentStream.endText();
            }

            document.save(outputFile);
            System.out.println("PDF Report generated: " + outputFile);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
}
