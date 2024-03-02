using System.Collections;
using System.Collections.Generic;
using UnityEngine;



public class AnimationHelper
{
    private static Vector2 dampVelocity = Vector2.zero;

    // 일정 속도로 화면 밖으로 내보내는 애니메이션
    public static IEnumerator Move(RectTransform rect, Define.Direction dir, float velocity)
    {
        Vector2 dirVec = Dir2Vec(dir);

        while (!IsOutScreen(rect))
        {
            rect.anchoredPosition += velocity * dirVec * Time.deltaTime;
            yield return null;
        }
    }


    public static IEnumerator Move(RectTransform rect, RectTransform target, float time)
    {
        dampVelocity = Vector2.zero;

        while (0.25f < Vector2.Distance(rect.anchoredPosition, target.anchoredPosition))
        {
            rect.anchoredPosition = Vector2.SmoothDamp(rect.anchoredPosition, target.anchoredPosition, ref dampVelocity, time);
            yield return null;
        }

        rect.anchoredPosition = target.anchoredPosition;
    }

    private static Vector2 Dir2Vec(Define.Direction dir)
    {
        switch (dir)
        {
            case Define.Direction.Up:
                return Vector2.up;

            case Define.Direction.Down:
                return Vector2.down;

            case Define.Direction.Left:
                return Vector2.left;

            case Define.Direction.Right:
                return Vector2.right;
        }

        return Vector2.zero;
    }

    public static bool IsOutScreen(RectTransform rect)
    {
        Vector2 screen = new Vector2(Screen.width, Screen.height);

        return rect.position.x + rect.sizeDelta.x < 0 || screen.x < rect.position.x + rect.sizeDelta.x || rect.position.y + rect.sizeDelta.y < 0 || screen.y < rect.position.y + rect.sizeDelta.y ;
    }
}
