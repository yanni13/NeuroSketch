package com.gtf.neuro_sketch.document;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.gtf.neuro_sketch.model.ImageAnalysisResult;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

@Document(collection = "image_analyses")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class ImageAnalysisDocument {
    @Id
    private String id;
    private String userId;
    private List<String> detectedObjects;
    private List<ObjectDetail> objectDetails;
    private List<String> colorsUsed;
    private List<String> dominantColors;
    private Composition composition;
    private DrawingCharacteristics drawingCharacteristics;
    private EmotionalIndicators emotionalIndicators;
    private TechnicalAnalysis technicalAnalysis;
    private OverallImpression overallImpression;
    private long createdAt;

    public static ImageAnalysisDocument from(ImageAnalysisResult result, String userId) {
        ImageAnalysisDocument document = new ImageAnalysisDocument();
        document.setUserId(userId);
        document.setDetectedObjects(result.getDetectedObjects());
        document.setObjectDetails(result.getObjectDetails());
        document.setColorsUsed(result.getColorsUsed());
        document.setDominantColors(result.getDominantColors());
        document.setComposition(result.getComposition());
        document.setDrawingCharacteristics(result.getDrawingCharacteristics());
        document.setEmotionalIndicators(result.getEmotionalIndicators());
        document.setTechnicalAnalysis(result.getTechnicalAnalysis());
        document.setOverallImpression(result.getOverallImpression());
        document.setCreatedAt(System.currentTimeMillis());
        return document;
    }

    @Data
    @NoArgsConstructor
    public static class ObjectDetail {
        @JsonProperty("object_name")
        private String objectName;
        private Position position;
        @JsonProperty("visual_characteristics")
        private VisualCharacteristics visualCharacteristics;
        @JsonProperty("spatial_relationships")
        private SpatialRelationships spatialRelationships;
        @JsonProperty("symbolic_indicators")
        private SymbolicIndicators symbolicIndicators;
    }

    @Data
    @NoArgsConstructor
    public static class Position {
        private String location;
        @JsonProperty("relative_size")
        private String relativeSize;
        private String prominence;
    }

    @Data
    @NoArgsConstructor
    public static class VisualCharacteristics {
        private List<String> colors;
        @JsonProperty("line_style")
        private String lineStyle;
        @JsonProperty("detail_level")
        private String detailLevel;
        @JsonProperty("completion_state")
        private String completionState;
    }

    @Data
    @NoArgsConstructor
    public static class SpatialRelationships {
        @JsonProperty("connection_to_others")
        private String connectionToOthers;
        @JsonProperty("interaction_type")
        private String interactionType;
        @JsonProperty("relative_placement")
        private String relativePlacement;
    }

    @Data
    @NoArgsConstructor
    public static class SymbolicIndicators {
        @JsonProperty("traditional_meaning")
        private String traditionalMeaning;
        @JsonProperty("art_therapy_significance")
        private String artTherapySignificance;
        @JsonProperty("contextual_meaning")
        private String contextualMeaning;
        @JsonProperty("emotional_expression")
        private String emotionalExpression;
    }

    @Data
    @NoArgsConstructor
    public static class Composition {
        private String balance;
        @JsonProperty("space_usage")
        private String spaceUsage;
        private String hierarchy;
    }

    @Data
    @NoArgsConstructor
    public static class DrawingCharacteristics {
        @JsonProperty("line_quality")
        private String lineQuality;
        @JsonProperty("drawing_style")
        private String drawingStyle;
        @JsonProperty("pressure_intensity")
        private String pressureIntensity;
    }

    @Data
    @NoArgsConstructor
    public static class EmotionalIndicators {
        @JsonProperty("color_temperature")
        private String colorTemperature;
        @JsonProperty("brightness_level")
        private String brightnessLevel;
        @JsonProperty("contrast_level")
        private String contrastLevel;
    }

    @Data
    @NoArgsConstructor
    public static class TechnicalAnalysis {
        @JsonProperty("completion_level")
        private String completionLevel;
        @JsonProperty("detail_level")
        private String detailLevel;
        private String organization;
    }

    @Data
    @NoArgsConstructor
    public static class OverallImpression {
        @JsonProperty("narrative_quality")
        private String narrativeQuality;
        @JsonProperty("emotional_tone")
        private String emotionalTone;
        @JsonProperty("energy_level")
        private String energyLevel;
    }
}