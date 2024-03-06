using Cinemachine;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Security.Claims;
using UnityEngine;

public class CharacterAttack : MonoBehaviour
{
    private bool prepared = true;
    private bool equipArrow = false;

    public enum AttackState
    {
        Wait,
        Aiming,
    }

    private PlayerInputAsset input;
    private AttackState state;
    public AttackState State => state;

    private Define.AttributeType arrowType;
    public Define.AttributeType ArrowType => arrowType;

    [SerializeField] private Transform arrowPos;
    [SerializeField] private Transform quiver;
    [SerializeField] private List<Arrow> arrowPrefabs;
    [SerializeField] private CinemachineVirtualCamera tpsCam;
    [SerializeField] private float chargeTime = 2.0f;
    [SerializeField] private AimTarget aimTarget;

    private Arrow arrow;

    private AttackPoint target;

    private float releaseTimeout = 0.25f;
    private float releaseTimeoutDelta = 0.0f;

    private float chargedAmount = 0.0f;

    private RaycastHit hit;
    private void Awake()
    {
        input = GetComponent<PlayerInputAsset>();
    }

    private void Update()
    {
        CheckPrepared();
        CheckTarget();
        UpdateAimTarget();
        CheckArrow();

        switch (state)
        {
            case AttackState.Wait:
                WaitUpdate();
                break;
            case AttackState.Aiming:
                AimingUpdate();
                break;
        }
    }

    // 공격 가능 상태인지 확인
    private void CheckPrepared()
    {
        Vector3 aimForward = aimTarget.transform.position - transform.position;
        aimForward.y = 0.0f;
        aimForward.Normalize();

        float angle = Vector3.Angle(aimForward, transform.forward);

        bool forwardCheck = angle < 140.0f;
        bool timeCheck = releaseTimeoutDelta < 0.0f;

        prepared = forwardCheck && timeCheck;
    }

    private void CheckTarget()
    {
        target = null;

        if (Physics.Raycast(Camera.main.transform.position, Camera.main.transform.forward, out hit, 100.0f))
        {
            if (hit.collider.TryGetComponent(out AttackPoint attackPoint))
            {
                target = attackPoint;
            }
        }
    }

    private void UpdateAimTarget()
    {
        if (target != null)
        {
            aimTarget.SetTarget(target.transform);
        }
        else
        {
            aimTarget.SetTarget(null);
        }

        float offset = Mathf.Lerp(10.0f, 0.0f, chargedAmount);
        aimTarget.SetAngle(offset);
    }

    private void CheckArrow()
    {
        if (arrow == null)
        {
            Arrow arrowPrefab = arrowPrefabs.Find((a) => a.ArrowData.Attribute == arrowType);
            arrow = Managers.Pool.Pop(arrowPrefab.gameObject, quiver).GetComponent<Arrow>();
            arrow.transform.SetLocalPositionAndRotation(Vector3.zero, Quaternion.identity);
            arrow.gameObject.SetActive(true);
            print("Reload Arrow");
        }
    }

    private void WaitUpdate()
    {
        chargedAmount = 0.0f;

        if (0.0f <= releaseTimeoutDelta)
        {
            releaseTimeoutDelta -= Time.deltaTime;
        }

        if (prepared && input.leftClick)
        {
            state = AttackState.Aiming;
        }
    }

    private void AimingUpdate()
    {
        if (equipArrow == false /*&& Vector3.Distance(arrow.transform.position, arrowPos.transform.position) < 10.0f*/)
        {
            arrow.transform.parent = arrowPos;
            arrow.transform.SetLocalPositionAndRotation(Vector3.zero, Quaternion.identity);
        }

        equipArrow = arrow.transform.parent == arrowPos;

        chargedAmount += Time.deltaTime / chargeTime;
        chargedAmount = Mathf.Clamp(chargedAmount, 0.0f, 1.0f);
        //TODO : HUD update

        if (prepared == false)
        {
            arrow.transform.parent = quiver;
            arrow.transform.SetLocalPositionAndRotation(Vector3.zero, Quaternion.identity);

            state = AttackState.Wait;
        }

        if (input.leftClick == false)
        {
            if (1.00f == chargedAmount)
            {
                ReleaseArrow();
            }
            else
            {
                arrow.transform.parent = quiver;
                arrow.transform.SetLocalPositionAndRotation(Vector3.zero, Quaternion.identity);
            }

            state = AttackState.Wait;
        }
    }

    private void ReleaseArrow()
    {
        if (target != null)
        {
            arrow.transform.parent = null;
            arrow.Shot(target);
            arrow = null;
        }
        else
        {
            arrow.transform.parent = quiver;
            arrow.transform.SetLocalPositionAndRotation(Vector3.zero, Quaternion.identity);
        }
    }
}
