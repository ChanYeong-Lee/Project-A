using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CompassUI : MonoBehaviour
{
    [SerializeField] private RectTransform indicator;
    [SerializeField] private RectTransform element;
    [SerializeField] private GameObject target;

    private RectTransform rect;
    private Vector3 startPos;
    private float threshold;
    private float angleChangeRate;
    private float angle = 0.0f;

    void Start()
    {
        if (target == null)
            target = GameObject.Find("CamTarget");

        rect = GetComponent<RectTransform>();
        threshold = (indicator.rect.width - rect.rect.width) * 0.5f;
        startPos = indicator.position;
        angleChangeRate = 50.0f / 90.0f;

        Vector3 targetForward = target.transform.forward;
        targetForward.y = 0;
        angle = Vector3.SignedAngle(Vector3.forward, targetForward, Vector3.up);
        angle = ClampAngle(angle);
        indicator.anchoredPosition = new Vector2(75.0f - angle * angleChangeRate, 0.0f);
    }

    void Update()
    {
        Vector3 targetForward = target.transform.forward;
        targetForward.y = 0;

        float nextAngle = Vector3.SignedAngle(Vector3.forward, targetForward, Vector3.up);
        nextAngle = ClampAngle(nextAngle);
        float deltaAngle = nextAngle - angle;
        indicator.anchoredPosition = new Vector2(indicator.anchoredPosition.x - deltaAngle * angleChangeRate, 0.0f);
        angle = nextAngle;

        if (120.0f < indicator.anchoredPosition.x)
        {
            indicator.anchoredPosition = new Vector2(indicator.anchoredPosition.x - 190.0f, 0.0f);
        }
        if (indicator.anchoredPosition.x < -120.0f)
        {
            indicator.anchoredPosition = new Vector2(indicator.anchoredPosition.x + 190.0f, 0.0f);
        }
    }

    private float ClampAngle(float angle)
    {
        if (angle < 0.0f)
        {
            angle += 360.0f;
        }

        return angle;
    }
}

