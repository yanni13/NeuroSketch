package com.gtf.neuro_sketch.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.gtf.neuro_sketch.document.ImageAnalysisDocument;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
public class ImageAnalysisResult {
    @JsonProperty("detected_objects")
    private List<String> detectedObjects;

    @JsonProperty("object_details")
    private List<ImageAnalysisDocument.ObjectDetail> objectDetails;

    @JsonProperty("colors_used")
    private List<String> colorsUsed;

    @JsonProperty("dominant_colors")
    private List<String> dominantColors;

    private ImageAnalysisDocument.Composition composition;

    @JsonProperty("drawing_characteristics")
    private ImageAnalysisDocument.DrawingCharacteristics drawingCharacteristics;

    @JsonProperty("emotional_indicators")
    private ImageAnalysisDocument.EmotionalIndicators emotionalIndicators;

    @JsonProperty("technical_analysis")
    private ImageAnalysisDocument.TechnicalAnalysis technicalAnalysis;

    @JsonProperty("overall_impression")
    private ImageAnalysisDocument.OverallImpression overallImpression;
}