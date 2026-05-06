import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:register_offline/core/dependency_injection/injection_container.dart'
    as di;
import 'package:register_offline/core/router/app_router.dart';
import 'package:register_offline/core/utils/app_theme.dart';
import 'package:register_offline/features/member/domain/entities/member.dart';
import 'package:register_offline/features/member/presentation/bloc/member_bloc.dart';
import 'package:register_offline/features/member/presentation/widgets/draft_member_card.dart';
import 'package:register_offline/features/member/presentation/widgets/uploaded_member_card.dart';
import 'package:register_offline/features/profile/presentation/bloc/profile_bloc.dart';

class HomePage extends StatelessWidget {
  final String token;

  const HomePage({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              di.serviceLocator<MemberBloc>()
                ..add(const MemberEventGetDrafts()),
        ),
        BlocProvider(
          create: (_) =>
              di.serviceLocator<ProfileBloc>()
                ..add(ProfileEventGetProfile(token: token)),
        ),
      ],
      child: _HomeView(token: token),
    );
  }
}

class _HomeView extends StatefulWidget {
  final String token;
  const _HomeView({required this.token});

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _navigateToAddMember() async {
    await context.push(AppRoutes.addMember, extra: widget.token);
    if (mounted) {
      context.read<MemberBloc>().add(const MemberEventGetDrafts());
    }
  }

  Future<void> _navigateToEditMember(MemberLocal member) async {
    await context.push(
      AppRoutes.editMember,
      extra: {'token': widget.token, 'member': member},
    );
    if (mounted) {
      context.read<MemberBloc>().add(const MemberEventGetDrafts());
    }
  }

  void _showSyncConfirmDialog(
    BuildContext context,
    MemberBloc bloc,
    int count,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Upload Semua Data',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Icon(
                Icons.cloud_upload_outlined,
                size: 80,
                color: AppTheme.primaryBlue,
              ),
              const SizedBox(height: 16),
              const Text(
                'Apakah kamu yakin ingin upload semua data?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Pastikan kamu sudah mengisi semua data yang diperlukan dengan benar, ya!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    bloc.add(MemberEventSyncAll(token: widget.token));
                  },
                  child: Text('Ya, Upload Semua ($count)'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Batal'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue,
                borderRadius: BorderRadius.circular(7),
              ),
              child: const Icon(
                Icons.badge_outlined,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Register Offline',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        actions: [
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              final name = state is ProfileStateLoaded
                  ? state.profile.fullName
                  : 'User';
              return GestureDetector(
                onTap: () async {
                  await context.push(
                    AppRoutes.profile,
                    extra: {'token': widget.token},
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.lightBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Text(
                        name.split(' ').first,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const CircleAvatar(
                        radius: 12,
                        backgroundColor: AppTheme.primaryBlue,
                        child: Icon(
                          Icons.person,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryBlue,
          unselectedLabelColor: AppTheme.textSecondary,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          indicatorColor: AppTheme.primaryBlue,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Draft'),
            Tab(text: 'Sudah Di-Upload'),
          ],
          onTap: (index) {
            if (index == 1) {
              context.read<MemberBloc>().add(
                MemberEventGetRemote(token: widget.token),
              );
            } else {
              context.read<MemberBloc>().add(const MemberEventGetDrafts());
            }
          },
        ),
      ),
      body: BlocConsumer<MemberBloc, MemberState>(
        listener: (context, state) {
          if (state is MemberStateSyncSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(state.message),
                  ],
                ),
                backgroundColor: AppTheme.successGreen,
                duration: const Duration(seconds: 3),
              ),
            );
            _tabController.animateTo(1);
            context.read<MemberBloc>().add(
              MemberEventGetRemote(token: widget.token),
            );
          } else if (state is MemberStateError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.errorRed,
              ),
            );
          } else if (state is MemberStateUploadSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.successGreen,
              ),
            );
            context.read<MemberBloc>().add(const MemberEventGetDrafts());
          }
        },
        builder: (context, state) {
          return TabBarView(
            controller: _tabController,
            children: [
              _buildDraftTab(context, state),
              _buildUploadedTab(context, state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDraftTab(BuildContext context, MemberState state) {
    List<MemberLocal> drafts = [];
    bool isLoading = state is MemberStateLoading;

    if (state is MemberStateDraftLoaded) {
      drafts = state.drafts;
    }

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFE8EDF8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: AppTheme.primaryBlue,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Upload untuk mengirimkan data ini ke admin untuk di-verifikasi.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.primaryBlue.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppTheme.primaryBlue),
                )
              : drafts.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: drafts.length,
                  itemBuilder: (_, i) => DraftMemberCard(
                    member: drafts[i],
                    index: i + 1,
                    onUpload: () {
                      context.read<MemberBloc>().add(
                        MemberEventUpload(
                          member: drafts[i],
                          token: widget.token,
                        ),
                      );
                    },
                    onEdit: () => _navigateToEditMember(drafts[i]),
                  ),
                ),
        ),
        Container(
          color: AppTheme.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah Data'),
                  onPressed: _navigateToAddMember,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.upload_outlined),
                  label: Text(
                    'Upload Semua${drafts.isNotEmpty ? ' (${drafts.length})' : ''}',
                  ),
                  onPressed: drafts.isEmpty
                      ? null
                      : () => _showSyncConfirmDialog(
                          context,
                          context.read<MemberBloc>(),
                          drafts.length,
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUploadedTab(BuildContext context, MemberState state) {
    List<MemberRemote> members = [];
    bool isLoading = state is MemberStateLoading;

    if (state is MemberStateRemoteLoaded) {
      members = state.members;
    }

    return isLoading
        ? const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryBlue),
          )
        : members.isEmpty
        ? _buildEmptyUploadedState()
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: members.length,
            itemBuilder: (_, i) =>
                UploadedMemberCard(member: members[i], index: i + 1),
          );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open_outlined,
            size: 80,
            color: AppTheme.textSecondary.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum ada data',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Klik "Tambah Data" untuk menambahkan\ndata calon anggota',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyUploadedState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_done_outlined,
            size: 80,
            color: AppTheme.textSecondary.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum ada data terupload',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Data yang sudah diupload akan tampil di sini',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}
