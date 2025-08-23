package com.gtf.neuro_sketch.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CareStatus {
    private String level;  // "즉시_관리_필요", "주의_관찰", "안정적", "양호함"
    private String description;  // 케어 상태에 대한 설명
    private int urgencyScore;  // 1-10 긴급도 점수
    private String reason;  // 해당 케어 상태로 판단한 이유
    private String recommendedAction;  // 권장 조치사항
}